Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab2LRRdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:33:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:14276 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab2LRRdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:33:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,309,1355126400"; 
   d="scan'208";a="235914687"
Message-ID: <50D0A8CE.7040704@linux.intel.com>
Date: Tue, 18 Dec 2012 09:33:02 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Youquan Song <youquan.song@intel.com>
CC: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        tglx@linutronix.de, mingo@kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,apic: Blacklist x2APIC on some platforms
References: <1355850450-26445-1-git-send-email-youquan.song@intel.com>
In-Reply-To: <1355850450-26445-1-git-send-email-youquan.song@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 09:07 AM, Youquan Song wrote:
> Blacklist x2apic when Nivida graphics enabled on Lenovo ThinkPad T420.
> Also set blacklist x2apic for Lenovo ThinkPad W520 and L520.

I thought we had gotten reports that the Nvidia correlation was false?

	-hpa


