Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2I2NVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 09:21:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:48506 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753855Ab2I2NVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 09:21:31 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19QN00ZTFZQp5gAI/cl/fc3P3awdRNWDT4cQRRVP2
	sOA8OFIPUf63X9
Message-ID: <5066F5D6.1000105@gmx.de>
Date: Sat, 29 Sep 2012 15:21:26 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>, Samuel Ortiz <sameo@linux.intel.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Daniel Mack <zonque@gmail.com>
Subject: Re: hot CPU with 3.6.0-rc7+ and intel graphic
References: <5066AD45.70107@gmx.de> <5066AE4B.9090000@gmx.de>
In-Reply-To: <5066AE4B.9090000@gmx.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to state it out explicitely, the power saving RC6 is broken on the GPU.

On 09/29/2012 10:16 AM, Toralf Förster wrote:
> 
> Hello,
> 
> I'm observed hot CPUs at my ThinkPad T420 (i5-2540M CPU) w/ integrated
> intel graphic with current git
> Powertop-2.1 shows that the GPU is always at 100%.
> 
> .config is attached
> 
> 
> I bisected this to
> 
> 
> commit a0e35322910555e20e9eced3f050a76c7b3a1f92
> Author: Feng Tang <feng.tang@intel.com>
> Date:   Thu Aug 16 15:50:10 2012 +0800
> 
>     mfd: lpc_ich: Fix a 3.5 kernel regression for iTCO_wdt driver



-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
