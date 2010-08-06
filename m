Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089Ab0HFJEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 05:04:37 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53087 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760804Ab0HFJEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 05:04:23 -0400
X-SpamScore: -36
X-BigFish: VPS-36(zz1432N9370J98dN936eM9371Pzz1202hzz15d4Rz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L6Q3V1-02-G54-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM
Date: Fri, 6 Aug 2010 11:04:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-24-generic; KDE/4.4.5; x86_64; ; )
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008060830.50889.stephan.diestelhorst@amd.com> <4C5BB472.5000207@gmail.com>
In-Reply-To: <4C5BB472.5000207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-ID: <201008061104.12574.stephan.diestelhorst@amd.com>
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

On Friday 06 August 2010, 09:06:26 Tejun Heo wrote:
> On 08/06/2010 08:30 AM, Stephan Diestelhorst wrote:
> > On Thursday 05 August 2010, 18:08:02 Tejun Heo wrote:
> >> Can you please try the following patch and see whether the problem
> >> goes away?
> > <snip>
> > 
> > to which revision does the patch apply? I didn't get it to apply
> > cleanly to Linus' kernel HEAD or the 2.6.34 stable tag. Maybe I am
> > missing something, since I am a git-n00b (use Mercurial all the time)?
> 
> It applies cleanly to v2.6.35.

Arrrgh. My "great" company Exchange mail server thought it was a good
idea to mess with the white-space of the mail. That's why the patch did
not apply. Compiling and testing now, sorry.

Stephan

-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

