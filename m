Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0DASWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 14:22:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56689 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab0DASWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 14:22:19 -0400
Date: Thu, 1 Apr 2010 20:22:17 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-mm@kvack.org
Subject: Re: 2.6.34-rc3, BUG at mm/slab.c:2989
Message-ID: <20100401182217.GA23177@fancy-poultry.org>
Reply-To: linux-kernel@vger.kernel.org
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org
References: <20100401175225.GA6581@fancy-poultry.org>
 <alpine.DEB.2.00.1004011257470.17168@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1004011257470.17168@router.home>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Wanderlust/2.15.7 (Almost =?utf-8?Q?Unreal?=
 =?utf-8?B?KSBTRU1JLzEuMTQuNiAoTWFydW9rYSkgRkxJTS8xLjE0LjkgKEdvasWNKSBB?=
 =?utf-8?Q?PEL=2F10=2E7?= Emacs/22.3 (x86_64-pc-linux-gnu) MULE/5.0 (SAKAKI)
X-Provags-ID: V01U2FsdGVkX1/PfaDEV+ExgV/9jpNWXtSlArH2FynDRgEhO+Q
 sVcjBP3zezSQRnWksTVANYCDiWre6i5X9vPa9UXnN2Kn3xu/Gz
 jPc+HhvvwofZVeXjsGWiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.04.2010, Christoph Lameter wrote: 

> Switch to SLUB and set SLUB_DEBUG_ON. Reboot and reproduce situation.
> Check the syslog after while. SLUB will repair the situation and continue
> if possible. There may not be failure.

Ok, will do immediately and try to reproduce. Thanks!

Heinz
