Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2FLWJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 18:09:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:59313 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab2FLWJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 18:09:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="152169145"
Message-ID: <4FD7BE15.50604@linux.intel.com>
Date: Tue, 12 Jun 2012 15:09:25 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 1/2] x86: Track minimum microcode revision globally v2
References: <1339536350-10463-1-git-send-email-andi@firstfloor.org> <20120612213905.GE26817@liondog.tnic>
In-Reply-To: <20120612213905.GE26817@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ok, is it only me or is this boot_min_microcode superfluous?
> IOW, you can only use boot_cpu_data.microcode instead and drop
> boot_min_microcode.

boot_cpu_data.microcode contains a copy of the original microcode,
so we couldn't detect the boot cpu case. In theory could hard code CPU 
#0 is boot cpu or so,
but I prefer to track it with the separate variable.

-Andi


