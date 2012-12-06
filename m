Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424822Ab2LFUwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 15:52:05 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:45100
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755257Ab2LFUwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 15:52:03 -0500
From: Tim Sander <tim01@vlsi.informatik.tu-darmstadt.de>
Organization: Sander & Lighting
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.6.9-rt21
Date: Thu, 6 Dec 2012 21:52:17 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-rc4-00136-gaffd9a8; KDE/4.8.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <alpine.LFD.2.02.1212051659160.2701@ionos> <201212061535.37585.tstone@iss.tu-darmstadt.de>
In-Reply-To: <201212061535.37585.tstone@iss.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212062152.17589.tim01@vlsi.informatik.tu-darmstadt.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
> Also: Has s.th. changed in respect to the modules. I have one module wich
> goes on an endless interrupt loop freezing the device. The driver works
> fine for 3.0  - 3.4 preempt rt kernels? This is a miscdev based driver. If
> someone is interested i can post the source over here. But unfortunatly i
> have not figured out why this thing goes to an endless interrupt. The
> identical driver works flawless on 3.4.

I have just crosschecked with 3.6.9. The same error as with the preempt rt 
version. So it's not an preempt rt problem.

Best regards
Tim
