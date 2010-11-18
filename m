Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab0KRSiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:38:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:4033 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab0KRSiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:38:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,218,1288594800"; 
   d="scan'208";a="678827723"
Date: Thu, 18 Nov 2010 18:18:14 +0000
From: Alan Cox <alan@linux.intel.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Feng Tang <feng.tang@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: platform: mrst: check
 platform_device_register() return code
Message-ID: <20101118181814.290811f0@linux.intel.com>
In-Reply-To: <1290104207-31279-1-git-send-email-segoon@openwall.com>
References: <1290104207-31279-1-git-send-email-segoon@openwall.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  I cannot compile this driver in next-20101117, so it is not tested
> at all.

Compile or test - if it bombs out compiling for you please send me (off
list the .config that fails so I can fix that

Otherwise NAK the patch because it needs to do the cleanup but thanks
for finding the bug - you've done the hard 99%

Alan
