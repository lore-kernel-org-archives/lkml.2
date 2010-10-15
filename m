Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0JOMYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:24:42 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2155 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab0JOMYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:24:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: mmotm 2010-10-13 - GSPCA SPCA561 webcam driver broken
Date: Fri, 15 Oct 2010 14:23:52 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-tschai; KDE/4.4.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org> <201010151202.31629.hverkuil@xs4all.nl> <4CB84393.3020205@redhat.com>
In-Reply-To: <4CB84393.3020205@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151423.52318.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 15, 2010 14:05:39 Mauro Carvalho Chehab wrote:
> Em 15-10-2010 07:02, Hans Verkuil escreveu:
> > On Friday, October 15, 2010 11:05:26 Andrew Morton wrote:
> >> On Fri, 15 Oct 2010 10:45:45 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>
> >>> On Thursday, October 14, 2010 22:06:29 Valdis.Kletnieks@vt.edu wrote:
> >>>> On Wed, 13 Oct 2010 17:13:25 PDT, akpm@linux-foundation.org said:
> >>>>> The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
> > 
> > Mauro, is this something for you to fix?
> 
> I have a patch fixing this conflict already:
> 
> http://git.linuxtv.org/mchehab/sbtvd.git?a=commit;h=88164fbe701a0a16e9044b74443dddb6188b54cc
> 
> The patch is currently on a separate tree, that I'm using to test some experimental
> drivers for Brazilian Digital TV system (SBTVD). I'm planning to merge this patch, among
> with other patches I received for .37 during this weekend.

No, this patch isn't sufficient. It backs out the wrong code but doesn't put
in the 'video_is_registered()' if statements that were in my original patch.

Those are really needed.

Regards,

	Hans
 
> The problem were due to a conflict between a BKL patch and your patch.
> 
> Cheers,
> Mauro.
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
