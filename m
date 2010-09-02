Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab0IBPgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:36:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40144 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0IBPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Jmfx/gG7xs57eSe2lLrGgHIqp39ylYu3AvP3u1qCevsfbawpTneRvq1pzovGulVyri
         Cc5aXGebRtrqX0Hexh9FZa9MTs/Wef8nPWe45cYIB/ZodgrYEDD4A6AM2qz/Sg441bxZ
         Y2OLvlmNLqPTlZxrt4jH0BWjNH8vitjbpbvkg=
MIME-Version: 1.0
Date: Thu, 2 Sep 2010 17:36:35 +0200
Message-ID: <AANLkTinFc+1wimmN3CQQzO-s3=uah8YDFzdy+Da=vsCx@mail.gmail.com>
Subject: Re: [PATCH 00/20] mm: Preemptibility -v4
From: Mat <jackdachef@gmail.com>
To: peterz@infradead.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, piotr@hosowicz.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I'm currently also testing your preemptibility patchset and have to
say that on top of 2.6.36-rc3 it really seems to make a positive
difference for me :)

since I'm only a regular (power)user utilizing linux-distributions for
my everyday work I can report only about that:

- the desktop stays very responsive even during copying, backing up
and transferring of large amounts of data (e.g. backing up 1 TB of
data via rsync between different filesystems); this includes the GUI
staying responsive, the mouse not lagging and apps opening up almost
instantaneously
- there is very little to no noticable lags or repetitions when
hearing webradio or audios during longer periods of time
- and much more


considering that 2.6.36 received several other improvements in this area
- http://lkml.org/lkml/2010/8/1/40, the patches from Wu Fengguang and
KOSAKI Motohiro
- concurrency managed workqueues
- and other performance improvements, especially VFS
may also add up to this

anyways: please consider adding this to next/mainline during the next
merge cycle

my linux-desktop didn't feel that reponsive for a long time ! ^^
if I recall correctly if felt comparably responsive when I used Con's
RSDL or SD scheduler - CFS and CFQ have made great progress in terms
of desktop usage, interactivity and delays

Regards and thanks to everyone involved in the continued improvements
in this area

Mat
