Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab2HVVz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:55:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54495 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab2HVVzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:55:55 -0400
Date: Wed, 22 Aug 2012 22:55:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Len Brown <len.brown@intel.com>, Feng Tang <feng.tang@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Sierra <asierra@xes-inc.com>, Bob Moore <robert.moore@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] lpc_ich: Fix a 3.5 kernel regression for iTCO_wdt
 driver
Message-ID: <20120822215543.GA1954@srcf.ucam.org>
References: <1344959772-23018-1-git-send-email-feng.tang@intel.com>
 <20120822195512.GI27604@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822195512.GI27604@spo001.leaseweb.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 09:55:12PM +0200, Wim Van Sebroeck wrote:

> Any idea why the acpi_check_resource_conflict() check gives a conflict?

Because the resource range is declared in ACPI and we assume that that 
means the firmware wants to scribble on it. We'd need the output of 
acpidump to work out whether that's safe or not.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
