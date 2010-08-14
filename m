Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab0HNVCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 17:02:54 -0400
Received: from 70.mail-out.ovh.net ([91.121.185.63]:34505 "HELO
	70.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755540Ab0HNVCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 17:02:53 -0400
Message-ID: <4C670478.4040609@example.com>
Date: Sat, 14 Aug 2010 23:02:48 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioctl definition - has it changed recently?
References: <4C67023D.6050603@example.com>
In-Reply-To: <4C67023D.6050603@example.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 322851798786863384
X-Ovh-Remote: 83.24.108.121 (doa121.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.08.2010 22:53, Piotr Hosowicz wrote:
> Hello,
>
> I build new kernels when they become available. Now I have a problem.
> After I install new kernel I have to run NVidia setup script. Starting
> from git15 it fails, see attached file. The error line is here:
>
> /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c: At top level:
> /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c:426: error:
> unknown field ‘ioctl’ specified in initializer
> /tmp/selfgz6622/NVIDIA-Linux-x86_64-256.35/kernel/nv.c:426: warning:
> initialization from incompatible pointer type
>
> In git14 everything was OK, but now it is not, also with the Git synced
> kernel. Has something changed from git14 times? I hope that it changed
> in Linux because it will be fixed earlier than NVidia source.
>
> My graphic card is 01:00.0 VGA compatible controller: nVidia Corporation
> G96 [GeForce 9400 GT] (rev a1)


The latest driver is here:

ftp://download.nvidia.com/XFree86/Linux-x86_64/256.44/

To unpack execute it with --extract-only option.

Regards,

Piotr Hosowicz

-- 
Na przyjęciu chłopak pyta blondynkę:
- Czy mogę cię prosić do walca?
- Zgłupiałeś? To już nie miałeś czym przyjechać?
NP: Peter Green Splinter Group - I Can't Help Myself
NB: 2.6.35-git14
