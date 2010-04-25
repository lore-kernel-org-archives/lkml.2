Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab0DYOqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 10:46:10 -0400
Received: from 26.mail-out.ovh.net ([91.121.27.225]:41108 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752384Ab0DYOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 10:46:07 -0400
Message-ID: <4BD455A8.5000603@example.com>
Date: Sun, 25 Apr 2010 16:46:00 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Jongman Heo <jongman.heo@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.34-rc5-git6] EIP: is at inet6_csk_bind_conflict + 06xe/0xb7
  [ipv6]
References: <m2z2d0a357f1004250613of5215185z1490aaae7363b161@mail.gmail.com> <loom.20100425T162010-523@post.gmane.org>
In-Reply-To: <loom.20100425T162010-523@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6172464765215535468
X-Ovh-Remote: 83.6.189.87 (abaz87.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.04.2010 16:26, Jongman Heo wrote:

> I also hit this bug today.

I also hit similar bug, maybe it is the same.

> Doing git bisect, first bad commit was
>
>   commit fda48a0d7a8412cedacda46a9c0bf8ef9cd13559
>   tcp: bind() fix when many ports are bound
>
> Reverting above commit fixes the problem.

How to do it? Would you please publish a reverting patch?

Regards,

Piotr Hosowicz

-- 
Szef TVN24 do dziennikarzy: Kochani, przez dwa lata walili¶my w obóz
rz±dz±cy. Tak dalej byc nie mo¿e. Jeste¶my telewizj± niezale¿n± i to
zobowi±zuje. Teraz bêdziemy kopaæ w opozycjê.
NP: Mark Knopfler - Remembrance Day
NB: 2.6.34-rc5-git5
