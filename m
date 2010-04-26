Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0DZVUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:20:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab0DZVUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:20:22 -0400
Message-ID: <eadb72941f097305cf185ed22294f795.squirrel@www.zytor.com>
In-Reply-To: <4BD600A7.609@oracle.com>
References: <4BC4E55B.7000103@oracle.com>
    <20100426183436.GV11130@hexapodia.org>
    <20100426123135.5d095d2f@virtuousgeek.org>
    <201004261427.57229.bjorn.helgaas@hp.com>
    <20100426133757.3e1d0a75@virtuousgeek.org> <4BD600A7.609@oracle.com>
Date: Mon, 26 Apr 2010 14:19:35 -0700
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below 
 BIOS_END
From: "H. Peter Anvin" <hpa@zytor.com>
To: "Yinghai" <yinghai.lu@oracle.com>
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Andy Isaacson" <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, guenter.roeck@ericsson.com,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas Renninger" <trenn@suse.de>, yaneti@declera.com
User-Agent: SquirrelMail/1.4.20-1.fc11
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.2 (terminus.zytor.com [127.0.0.1]); Mon, 26 Apr 2010 14:19:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> but looks -v4 is too tricky.
>

Let's distinguish between what we need for .34 -- we need something
minimal and as soon as possible at this stage -- and concentrate on
getting the right thing to happen going forward.

       -hpa


