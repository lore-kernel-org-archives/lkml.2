Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab1D0WUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:20:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:33289 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab1D0WUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:20:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,276,1301900400"; 
   d="scan'208";a="739369977"
Message-ID: <4DB896B5.7090506@linux.intel.com>
Date: Wed, 27 Apr 2011 15:20:37 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: tim.gardner@canonical.com, wey-yi.w.guy@intel.com,
        Andi Kleen <andi@firstfloor.org>, donald.h.fry@intel.com,
        sgruszka@redhat.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [96/106] iwlagn: Support new 5000 microcode.
References: <20110426212.641772347@firstfloor.org> <20110426211418.AF9B93E1886@tassilo.jf.intel.com>            <4DB85596.4070105@canonical.com> <38255.1303937247@localhost>
In-Reply-To: <38255.1303937247@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I can't speak to Ubuntu, but I hit this on Fedora Rawhide a while ago, they
> ended including several versions so different kernels would work OK:
>
> % rpm -ql iwl5000-firmware
> /lib/firmware/iwlwifi-5000-1.ucode
> /lib/firmware/iwlwifi-5000-2.ucode
> /lib/firmware/iwlwifi-5000-5.ucode

I don't want people require to install new firmware for .35. This sounds 
like I should
drop this patch. Wey-yi?

-Andi

