Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1EQQil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 12:38:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50982 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab1EQQil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 12:38:41 -0400
Message-ID: <4DD2A496.8000407@web.de>
Date: Tue, 17 May 2011 18:38:46 +0200
From: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Nick Bowler <nbowler@elliptictech.com>,
        =?UTF-8?B?SsO2cmctVm9sa2VyIFBl?= =?UTF-8?B?ZXR6?= 
	<jvpeetz@web.de>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/2] AMD ARAT fixes
References: <1305636919-31165-1-git-send-email-bp@amd64.org>
In-Reply-To: <1305636919-31165-1-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:oNABIPidk522oeGEfp8aHXJ3fNzokK4LIMs9VHC4ZlR
 Ji0XgAZrbheMb7EGeCTtVxqxHbYyeuougwrkCINu1drw+9mdoQ
 GaItusdDai1bmcumbJifFRwiGXmr5912YS2lgHz7lwOmK46mpg
 CR5wVSCN0s+GRBUIIFhAgsHmye3XgYPgaADYqOvvy/6tjXkjmF
 0VYwondjkAMzLW5LouHlw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote, on 05/17/11 14:55:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi all,
> 
> the following 2 patches address the fallout caused by
> b87cf80af3ba4b4c008b4face3c68d604e1715c6. They enable ARAT only on
> Fam10h and later, and leaves out K8 due to multiple problems there.
> 
> Although the patches look almost trivial, I'd like to ask Nick and
> Jörg-Volker to test them, please, so that we can have a confirmation,
> just in case.
> 
> Then, if we're lucky and Linus hasn't released .39 yet, we might sneak
> them in, if we ask people politely :).
> 
> Thanks.
> 
> 

A kernel version 2.6.38.6 patched with your two patches modifying only
arch/x86/kernel/cpu/amd.c starts and runs without problems on the affected
system with a AMD Turion 64 processor. The system is pure x86_64 (Debian
Release: wheezy/sid) with gcc version 4.6.1 20110428 (prerelease) (Debian
4.6.0-6) and GNU C Library (Debian EGLIBC 2.13-4) stable release version 2.13.

The only obvious difference I see is the message "using C1E aware idle routine"
in dmesg.
-- 
Best regards,
Jörg-Volker.

