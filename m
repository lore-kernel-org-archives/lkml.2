Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0IWSyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:54:12 -0400
Received: from borg.medozas.de ([188.40.89.202]:54623 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab0IWSyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:54:11 -0400
Date: Thu, 23 Sep 2010 20:54:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: "Glove box" BIOS patch causes boot flicker
In-Reply-To: <4C994F0B.6030004@linux.intel.com>
Message-ID: <alpine.LNX.2.01.1009232052230.16976@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1009220135380.25692@obet.zrqbmnf.qr> <4C994F0B.6030004@linux.intel.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 2010-09-22 02:34, H. Peter Anvin wrote:

>There were some minor bugs (typos) in the conversion to the glove box 
>coding style. The ones we have found have been fixed, so the first 
>thing is to try the current mainline or the current tip tree.  
>Otherwise I would look for issues where either the wrong register is 
>changed, or something like a variable is changed instead of a field.

I tried v2.6.36-rc5 now, and it looks better. The cursor position is 
retained as desired. The mode switch is still there, albeit much 
shorter than it used to be.
