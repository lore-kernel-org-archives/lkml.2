Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0IVAeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 20:34:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:24136 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab0IVAeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 20:34:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,403,1280732400"; 
   d="scan'208";a="659766783"
Message-ID: <4C994F0B.6030004@linux.intel.com>
Date: Tue, 21 Sep 2010 17:34:19 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: "Glove box" BIOS patch causes boot flicker
References: <alpine.LNX.2.01.1009220135380.25692@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1009220135380.25692@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A "glove box" is a device used to handle toxic stuff.  In this case the 
toxic stuff is the BIOS.

There were some minor bugs (typos) in the conversion to the glove box 
coding style.  The ones we have found have been fixed, so the first 
thing is to try the current mainline or the current tip tree.  Otherwise 
I would look for issues where either the wrong register is changed, or 
something like a variable is changed instead of a field.



	-hpa
