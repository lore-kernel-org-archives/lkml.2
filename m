Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab0HPG7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 02:59:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0HPG7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 02:59:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: piotr@hosowicz.com
Subject: Re: ioctl definition - has it changed recently?
Date: Mon, 16 Aug 2010 08:58:42 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.92; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
References: <4C67023D.6050603@example.com> <20100814210044.GA29375@merkur.ravnborg.org> <4C671455.4040908@example.com>
In-Reply-To: <4C671455.4040908@example.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008160858.42947.arnd@arndb.de>
X-Provags-ID: V02:K0:UoEqliKbgajOZc7QG81OPZb0TaG+9V50rvi+V2fMDoQ
 zB1lA6CRCo/8ehwZeBe4UTLldnbPDjtPQseoGgT6Vrs6yphZB7
 lp/lgP0Sf5/m4KrWygUob9AMjzYCEmvoz8GbTJNVMrK/CpLzc0
 d8o3HGOpfwkXyfjBr5DgnMFIsOSyMJbwnFqKj4fLR4y/7e1YhF
 fnKESKeM9agd74S63/T0Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 August 2010 00:10:29 Piotr Hosowicz wrote:
> Yes, this was it. I made git pull and git revert and now I am up and 
> kicking. But how will I manage with it not by git but by kernel org 
> provioded files? And even if I used git all the time will I have to 
> revert it each time and what's the worse I will become more and more out 
> of sync because people will write their code as if I did not revert.

Just fix your driver code to no longer rely on the big kernel lock
and then make it use the unlocked_ioctl operation.

	Arnd
