Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab2BZKRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 05:17:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:63857 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934Ab2BZKRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 05:17:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="114981697"
Message-ID: <4F4A0662.4050909@intel.com>
Date: Sun, 26 Feb 2012 18:16:02 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        andiry.xu@amd.com, clemens@ladisch.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] usb: enable pci MSI/MSIX in usb core
References: <1329728733-32419-1-git-send-email-alex.shi@intel.com> <1329728733-32419-2-git-send-email-alex.shi@intel.com> <1329728733-32419-3-git-send-email-alex.shi@intel.com> <20120223034147.GD27250@xanatos> <20120223124147.GL18463@legolas.emea.dhcp.ti.com> <1330048028.21053.1176.camel@debian> <20120224100051.GF17178@legolas.emea.dhcp.ti.com>
In-Reply-To: <20120224100051.GF17178@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>

> sure, makes sense, but that should be static inline I guess.
> 


Yes, thanks for reminder!
