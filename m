Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab0E0Iw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 04:52:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab0E0Iwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 04:52:54 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH 8/8] intel_idle: create a native cpuidle driver for select intel processors
Date: Thu, 27 May 2010 10:53:30 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, x86@kernel.org,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
References: <1274928151-30919-1-git-send-email-lenb@kernel.org> <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
In-Reply-To: <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005271053.31087.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010 04:42:31 Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
... 
> CONFIG_INTEL_IDLE=m is not recommended unless the system
> has a method to guarantee intel_idle loads before ACPI's
> processor_idle.
Then it should better be declared bool instead of tristate until it
works.

> This driver does not yet know about cpu online/offline
> and thus will not yet play well with cpu-hotplug.
What means does not play well yet, suspend or manually offlining a core 
will eventually (for sure?) hang the machine?

If this is known broken, should this already be spread through
linux-next?

    Thomas
