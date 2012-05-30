Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2E3Sdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:33:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42582 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab2E3Sdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:33:40 -0400
Subject: Re: [GIT PULL] Block driver bits for 3.5
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4FC6189B.9080909@fusionio.com>
References: <4FC6189B.9080909@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 May 2012 20:33:32 +0200
Message-ID: <1338402812.2760.413.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 14:54 +0200, Jens Axboe wrote:
> Hi Linus,
> 
> On top of the for-3.5/core pull request, here are the driver related
> changes for 3.5. It contains:

Hi Jens

Not sure if this is related, but latest Linus tree cannot boot anymore
here...

BUG: soft lockup - CPU#3 stuck for 22s ! [mountall.1603]



