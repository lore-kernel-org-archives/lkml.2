Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab0IHJPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:15:44 -0400
Received: from gw1.transmode.se ([213.115.205.20]:34863 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758580Ab0IHJPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:15:40 -0400
In-Reply-To: <1283934289.2880.12.camel@edumazet-laptop>
References: <OF71DD00AE.26643E4D-ONC1257798.00250630-C1257798.002A9748@transmode.se>	 <1283932600.2880.1.camel@edumazet-laptop>
	 <OF5074952F.1B97B2B8-ONC1257798.002C51D7-C1257798.002C63A4@transmode.se> <1283934289.2880.12.camel@edumazet-laptop>
Subject: Re: slow nanosleep?
X-KeepSent: 2B75FA7C:7064BC41-C1257798:00318FDA;
 type=4; name=$KeepSent
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OF2B75FA7C.7064BC41-ONC1257798.00318FDA-C1257798.00329AEF@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 8 Sep 2010 11:12:44 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1FP3|May 23, 2010) at
 2010-09-08 11:15:39
MIME-Version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote on 2010/09/08 10:24:49:
>
> Le mercredi 08 septembre 2010 à 10:04 +0200, Joakim Tjernlund a écrit :
>
> > That makes litte difference:
> > root@localhost ~ # ./nanosleep
> > nanosleep
> > req:0 :0
> > tv_res:0 :112
> >
>
> Here, result is 30 (with prctl())
> instead of 95 (without)

On x86 I notice a difference:
  7 vs 57.
however select is still faster: 2
The system call OH seems to be bigger for nanosleep than
for select and on my ppc is is about 112 us. Can anything
be done about that?

  Jocke

