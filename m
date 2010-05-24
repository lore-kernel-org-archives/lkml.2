Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab0EXRWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 13:22:52 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:33746 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758044Ab0EXRWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 13:22:50 -0400
Message-ID: <4BFAB5E4.6020401@example.com>
Date: Mon, 24 May 2010 19:22:44 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: piotr@hosowicz.com
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 icedove-bin/5449
References: <4BF9EC69.5030709@example.com>
In-Reply-To: <4BF9EC69.5030709@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13107163767290097944
X-Ovh-Remote: 95.49.244.217 (afjk217.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.05.2010 05:03, Piotr Hosowicz wrote:

> I had this error in linux-next and reported it, but nobody answered :-(
> Now it's here, in fresh git source built kernel. After I boot the screen
> becomes cluttered with messages as in subject line. I attach dmesg and
> cpuinfo.

I've just git pulled latest kernel source, built the kernel, but the 
problem still persists.

Cheers,

Piotr Hosowicz

-- 
TV: "Jeszcze trzy ruchy i Otylia bêdzie szczê¶liwa."
NP: Slash - Ghost (Feat. Ian Astbury)
NB: 2.6.34-20100524-1752
