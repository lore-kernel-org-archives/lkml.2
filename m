Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab1CPQxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 12:53:47 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:60067 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752335Ab1CPQxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 12:53:41 -0400
Message-ID: <4D80EB11.1000703@example.com>
Date: Wed, 16 Mar 2011 17:53:37 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: LKML <linux-kernel@vger.kernel.org>
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: That's up with git1? Or with me?
References: <4D80B773.4070100@example.com>
In-Reply-To: <4D80B773.4070100@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 16938601150038765848
X-Ovh-Remote: 178.36.169.66 (178-36-169-66.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.03.2011 14:13, Piotr Hosowicz wrote:
> Hello,
>
> I tried to have a new kernel for 2.6.38-git1 kernel and tried to apply
> the patch, but it failed for the Makefile (it didn't expect rc8 suffix)
> and 40 failures for fs/namei.c file. I took the file from my GIT tree
> updated from Linus' repo. It seems to work, as you see ;-) But I am
> curious what I am doing wrong?

It was my fault, I had wrong base for the patch, rc8 instead of plain 
2.6.38.

Regards and sorry for the noise.

Piotr Hosowicz

-- 
Radzieccy neurolodzy odkryli nerw ³±cz±cy oko bezpo¶rednio z dup±.
Kiedy uk³uli pacjenta ig³± w dupê, w jego oku pojawi³a siê ³za.
Kiedy wbili tê sam± ig³ê w oko, pacjent siê zesra³.
NP: delusion squared -
NB: 2.6.38-rc8-frankenstein
