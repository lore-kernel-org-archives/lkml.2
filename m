Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0JDGrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 02:47:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58710 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab0JDGrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 02:47:45 -0400
Date: Mon, 4 Oct 2010 08:47:43 +0200
From: Heinz Diehl <htd@fritha.org>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [cpufreq] ondemand: Intel i5-450M gets stuck in lowest state
Message-ID: <20101004064743.GA7237@fritha.org>
References: <20101003190012.GA29952@fritha.org>
 <201010032316.52532.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010032316.52532.trenn@suse.de>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Wanderlust/2.15.7 (Almost =?utf-8?Q?Unreal?=
 =?utf-8?B?KSBTRU1JLzEuMTQuNiAoTWFydW9rYSkgRkxJTS8xLjE0LjkgKEdvasWNKSBB?=
 =?utf-8?Q?PEL=2F10=2E7?= Emacs/22.3 (x86_64-pc-linux-gnu) MULE/5.0 (SAKAKI)
X-Provags-ID: V02:K0:E+G6+80rWNQBRrnvVA95iXfVJEfInfL5lK314L155kw
 zFG3bi1F1iGvoeiL/tRczNMVL+vkS2N3vMlol5lR2DZVMVD3lF
 jdLg8vw1FXxMXVo3f0stgAlSTDt2lH+Wyb2XcYyUjqehLU5uDA
 8NTeTxBezlbiJDGe7eCovuPfLsEtte0KF+IaZlZ2TCdtuhpru2
 P/06LfDMI1hLX/3kdkR+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.10.2010, Thomas Renninger wrote: 

> best you open a bug on:
> https://bugzilla.kernel.org
> attach acpidump and dmesg and paste below as description.

Ok, did it:
https://bugzilla.kernel.org/show_bug.cgi?id=19702

> The root cause should be ACPI related, the patch is in the cpufreq subsystem,
> can you assign the bug against ACPI and also CC myself and the cpufreqlist:
> cpufreq@vger.kernel.org

Done.

> Eh, best you also check for a BIOS update, this could fix it.

There's no update per today, it's the latest Bios 207 for this machine.

Thanks, Heinz.
