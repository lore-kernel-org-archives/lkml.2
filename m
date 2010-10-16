Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0JPUwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 16:52:16 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:37535 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754278Ab0JPUwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 16:52:15 -0400
Message-ID: <4CBA107B.3000508@example.com>
Date: Sat, 16 Oct 2010 22:52:11 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Elvis Dowson <elvis.dowson@mac.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Alternate git repo servers
References: <2D81AEF9-2724-4187-8D69-1C1282ADBCC9@mac.com> <7B26AF36-809D-4044-AC14-0CB7985E2D50@mac.com> <4CBA0D1C.6000805@example.com> <52F86985-723A-40BB-9C3E-2CC11A49BD2A@mac.com>
In-Reply-To: <52F86985-723A-40BB-9C3E-2CC11A49BD2A@mac.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 1187824402436288906
X-Ovh-Remote: 83.6.195.253 (abbf253.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.10.2010 22:43, Elvis Dowson wrote:

> Yes, just type
>
> git clone http://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
>
> Are you also experiencing slowness with the git protocol with the servers on git.kernel.org&  gitorious.org.

I had it some days ago with kernel.org, but I substituted the host part 
with some different hostname, I saw that other announed a minute ago 
with some git-pull request on LKML - and it worked, it could be pure luck.

Thanks,

Piotr Hosowicz

-- 
- Czy jest cukier w kostkach ?
- Nie ma.
- A jakas inna tania bombonierka? Dla tesciowej.
NP: Creedence Clearwater Revival - Graveyard Train
NB: 2.6.36-rc8-git3
