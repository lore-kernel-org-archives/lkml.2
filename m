Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab2FUKkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:40:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47689 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab2FUKkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:40:14 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXiva_U2R5M+e8LbuM+juHAYaRR5m7ma5H+Nw6+6mqx-Qw@mail.gmail.com>
References: <CANQmPXip+fKaSYsKaY5TF3Rax=XFFgyh=+BY61snVsgpReL7RA@mail.gmail.com>
	<1339914285.7349.75.camel@marge.simpson.net>
	<CANQmPXiU_Pz2qZkisF34TBepbRW4iJ4ytLLfiEmuJpCHxUwWvA@mail.gmail.com>
	<CANQmPXi=p0WvJ0GofWFSG8Um6trHw3ejwR-TazZyoXm9g-trJQ@mail.gmail.com>
	<4d5440bc-73bb-4c30-8571-bb7004fc5c4a@skytron.local>
	<CANQmPXiva_U2R5M+e8LbuM+juHAYaRR5m7ma5H+Nw6+6mqx-Qw@mail.gmail.com>
Date: Thu, 21 Jun 2012 18:40:13 +0800
Message-ID: <CANQmPXiGeUv1N7=OJ2Cm=s1X+UMExDPwAFtctCbN64yeEzkz+Q@mail.gmail.com>
Subject: Re: Unzustellbar: Re: [PATCH][ANNOUNCE]RIFS-ES Scheduling V1 release.
From: Chen <hi3766691@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        mou Chen <hi3766691@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a newer benchmark around latt -c255 sleep 10 between these 3
cpu scheduler.
http://rifs-scheduler.googlecode.com/files/Result-003.PNG

RIFS-ES-Low-Spec has been posted, if you want a link please click the
follow site.(The testing data in test form and PNG statistic form)
http://code.google.com/p/rifs-scheduler/downloads/detail?name=Result-003.PNG

During the test I will move the mouse(I just move the mouse and I
don't click anything).
With BFS the mouse stalls.
With CFS or RIFS-ES-Low-Spec the mouse is very smooth.

With average latency RIFS wins, with maximum latency BFS wins.

After using it if you think it is useful please invite the others to use it.
Thanks
