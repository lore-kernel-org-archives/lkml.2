Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0F1S6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 14:58:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:54116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab0F1S6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 14:58:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,498,1272870000"; 
   d="scan'208";a="531048322"
Message-ID: <4C28F0DE.9040109@linux.intel.com>
Date: Mon, 28 Jun 2010 11:58:38 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/alternatives] x86, alternatives: Use 16-bit numbers
 for cpufeature index
References: <tip-*@git.kernel.org> <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org> <4C2474EF.4050902@cn.fujitsu.com> <4C24CCB7.2020806@zytor.com> <4C285625.6000806@cn.fujitsu.com>
In-Reply-To: <4C285625.6000806@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 12:58 AM, Lai Jiangshan wrote:
> 
> There is alternative in use_xsave().
> use_xsave() should return false in my system, but it returns true after this patch applied.
> 

OK, so a false substitution... strange.

	-hpa

