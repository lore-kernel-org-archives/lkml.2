Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab0KRUjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:39:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:25219 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab0KRUjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:39:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,218,1288594800"; 
   d="scan'208";a="350553303"
Date: Thu, 18 Nov 2010 20:19:28 +0000
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
Message-ID: <20101118201928.50e249fb@linux.intel.com>
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

On Thu, 18 Nov 2010 21:16:45 +0300
Vasiliy Kulikov <segoon@openwall.com> wrote:

> platform_device_register() may fail, if so propagate the return
> code from mrst_device_create().
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>

On further inspection this fix is actually correct as the other
cleanup got moved to the arch/x86 driver.

Alan
