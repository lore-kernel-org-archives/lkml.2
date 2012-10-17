Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab2JQRF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:05:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:55910 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757469Ab2JQRFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:05:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,602,1344236400"; 
   d="scan'208";a="228816355"
Message-ID: <507EE571.60104@zytor.com>
Date: Wed, 17 Oct 2012 10:05:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] RAS: Numascale fix
References: <20121009130402.GB26450@aftab.osrc.amd.com>
In-Reply-To: <20121009130402.GB26450@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 06:04 AM, Borislav Petkov wrote:
> Hi guys,
> 
> just a small fix for an oops on Numascale's confederate systems. It can
> go in ASAP.
> 

For small git pulls, it would be good to include the actual diff in the
pull request.

	-hpa

