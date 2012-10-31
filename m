Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2JaJ76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:59:58 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:56096 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab2JaJ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:59:56 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@parisplace.org>
Subject: Re: NULL pointer dereference at fat_detach
References: <20121030134449.GA5435@redhat.com>
	<1351632646.1339.72.camel@x61.thuisdomein>
	<87y5in8nys.fsf@devron.myhome.or.jp>
	<1351676454.1339.99.camel@x61.thuisdomein>
Date: Wed, 31 Oct 2012 18:59:43 +0900
In-Reply-To: <1351676454.1339.99.camel@x61.thuisdomein> (Paul Bolle's message
	of "Wed, 31 Oct 2012 10:40:54 +0100")
Message-ID: <87ehkf6jxs.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> writes:

> On Wed, 2012-10-31 at 09:49 +0900, OGAWA Hirofumi wrote:
>> This bug is known as the inotify bug. I recall I talked about this,
>> maybe years ago.
>
> Would that be this thread: https://lkml.org/lkml/2011/6/10/155 ?

Sure, exactly.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
