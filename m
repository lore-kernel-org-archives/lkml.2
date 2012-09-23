Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2IWFyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 01:54:47 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33173 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab2IWFyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 01:54:46 -0400
Date: Sat, 22 Sep 2012 22:54:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Matthew Garrett <mjg@redhat.com>, Lan Tianyu <tianyu.lan@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 14/23] usb-acpi: Comply with the ACPI API change
Message-ID: <20120923055441.GA21084@kroah.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1348371388.git.len.brown@intel.com>
 <59e6423ba8aaa42289457a15ffc7d111a955a2fa.1348371388.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59e6423ba8aaa42289457a15ffc7d111a955a2fa.1348371388.git.len.brown@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2012 at 12:34:02AM -0400, Len Brown wrote:
> From: Feng Tang <feng.tang@intel.com>
> 
> acpi_get_physical_device_location()'s 2nd argument has been changed
> in ACPI implementaion, so need a follow-on change in
> usb_acpi_check_pld().
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Lan Tianyu <tianyu.lan@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
