Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2EMSL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 14:11:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35998 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751100Ab2EMSL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 14:11:28 -0400
Message-ID: <1336932688.2656.6.camel@joe2Laptop>
Subject: Re: [PATCH 1/2] fat: add fat_msg_ratelimit.
From: Joe Perches <joe@perches.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Date: Sun, 13 May 2012 11:11:28 -0700
In-Reply-To: <877gwgdptk.fsf@devron.myhome.or.jp>
References: <1336907005-18602-1-git-send-email-linkinjeon@gmail.com>
	 <1336923908.31383.4.camel@joe2Laptop> <877gwgdptk.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 01:10 +0900, OGAWA Hirofumi wrote:
> Joe Perches <joe@perches.com> writes:
> > On Sun, 2012-05-13 at 07:03 -0400, Namjae Jeon wrote:
> >> I tried to add fat_msg_ratelimit to limit many message at once.
[]
> > #define fat_msg_ratelimit(sb, level, fmt, args...)		\
> > do {								\
> > 	if (! __ratelimit(&MSDOS_SB(sb)->ratelimit))		\

This should be
	if (__ratelimit(etc..))




