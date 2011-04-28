Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab1D1IiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:38:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:38093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab1D1IiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:38:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,279,1301900400"; 
   d="scan'208";a="635228358"
Date: Thu, 28 Apr 2011 09:22:10 +0100
From: Alan Cox <alan@linux.intel.com>
To: "Weil, Oren jer" <oren.jer.weil@intel.com>
Cc: Greg KH <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@woodhou.se" <david@woodhou.se>
Subject: Re: [PATCH 8/8] staging/mei: Updates to staging/Kconfig ane
 staging/Makefile and a new Makefile and Kconfig
Message-ID: <20110428092210.7a33295a@bob.linux.org.uk>
In-Reply-To: <F28B59AD52D84B479DCA469824475335065AF92FB1@hasmsx503.ger.corp.intel.com>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
	<1303900057-21694-9-git-send-email-oren.jer.weil@intel.com>
	<20110427150651.GD24596@suse.de>
	<F28B59AD52D84B479DCA469824475335065AF92FB1@hasmsx503.ger.corp.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011 09:39:57 +0300
"Weil, Oren jer" <oren.jer.weil@intel.com> wrote:

> >On Wed, Apr 27, 2011 at 01:27:37PM +0300, Oren Weil wrote:
> 
> >> +config INTEL_MEI
> >> +	tristate "Intel Management Engine Interface (Intel MEI)"
> >> +	depends on X86 && EXPERIMENTAL
> >
> >You need a lot more dependencies here, please fix this.
> 
> Can you give me an example ?

PCI ?
