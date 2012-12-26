Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab2LZEdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 23:33:36 -0500
Received: from ares07.inai.de ([5.9.24.206]:39524 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab2LZEdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 23:33:33 -0500
Date: Wed, 26 Dec 2012 05:33:31 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Dave Chinner <david@fromorbit.com>
cc: Andreas Dilger <adilger@dilger.ca>, ys <sickamd@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] vfs: update atimes over one day in the past or future
In-Reply-To: <20121218211451.GE15182@dastard>
Message-ID: <alpine.LNX.2.01.1212260530580.20128@nerf07.vanv.qr>
References: <50CC9663.4010200@gmail.com> <20121216021508.GG9806@dastard> <60E209F1-F797-42C2-9F41-43BF7839B2A3@dilger.ca> <20121218211451.GE15182@dastard>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2012-12-18 22:14, Dave Chinner wrote:
>
>> >> CC: stable@vger.kernel.org
>> >> ---
>> >> fs/inode.c | 7 ++++---
>> >> 1 ??????????????????????????? 4 ???(+)????????? 3 ???(-)
>> > 
>> > There's something wrong with the character encoding you are using...
>> 
>> Chinese locale, but probably doesn't matter since text below "---" isn't in the commit anyway?
>
>Yup, but it doesn't inspire confidence that the patch is going to be
>clean when multiple encodings appear in the one message...

Multiple encodings are not much of a problem. Lack of specifying them,
as happened with that attachment, is.

That's another reason why inline patches work better, because the
main message part has the encoding set most of the time :)
