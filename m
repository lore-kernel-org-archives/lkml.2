Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab2ECVMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:12:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53594 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2ECVMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:12:34 -0400
Message-ID: <1336079536.6509.24.camel@twins>
Subject: Re: [PATCH 7/9] perf: Add Sandy Bridge-EP uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 23:12:16 +0200
In-Reply-To: <1335924440-11242-8-git-send-email-zheng.z.yan@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
	 <1335924440-11242-8-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's keep the names as they're listed in the Intel doc:

On Wed, 2012-05-02 at 10:07 +0800, Yan, Zheng wrote:
> +static struct intel_uncore_type snbep_uncore_ubox = {
> +       .name           = "ubox",

"U-Box"

> +};
> +
> +static struct intel_uncore_type snbep_uncore_cbo = {
> +       .name           = "cbo",

"C-Box"

> +};
> +
> +static struct intel_uncore_type snbep_uncore_pcu = {
> +       .name           = "pcu",

"PCU"

> +};


> +static struct intel_uncore_type snbep_uncore_ha = {
> +       .name           = "ha",

"HA"

> +};
> +
> +static struct intel_uncore_type snbep_uncore_imc = {
> +       .name           = "imc",

"iMC"

> +};
> +
> +static struct intel_uncore_type snbep_uncore_qpi = {
> +       .name           = "qpi",

"QPI"

> +};
> +
> +
> +static struct intel_uncore_type snbep_uncore_r2pcie = {
> +       .name           = "r2pcie",

"R2PCIe"

> +};
> +
> +static struct intel_uncore_type snbep_uncore_r3qpi = {
> +       .name           = "r3qpi",

"R3QPI"

> +}; 

These last two are the P-Boxes ? The figure (1-1) lists a 3rd P-box
covering the SMI channels, the table (1-1) doesn't list it though.


