Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0DWTVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:21:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49778 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab0DWTVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:21:08 -0400
Date: Fri, 23 Apr 2010 20:20:59 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: =?iso-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       platform-driver-x86@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       "Brown, Len" <len.brown@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Make WMI be selected automatically when needed
Message-ID: <20100423192059.GA32705@srcf.ucam.org>
References: <4BC8FF9D.7050500@tremplin-utc.net> <20100416173127.6b968fd4.randy.dunlap@oracle.com> <4BC907B5.2050104@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BC907B5.2050104@tremplin-utc.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 17, 2010 at 02:58:29AM +0200, Éric Piel wrote:

>  config LEDS_DELL_NETBOOKS
>  	tristate "External LED on Dell Business Netbooks"
> -	depends on X86 && ACPI_WMI
> +	depends on X86
> +	depends on ACPI
> +	select ACPI_WMI

I dislike this. The originally stated dependencies are correct and more 
accurately represent what the code requires, and changing that for the 
sake of making it easier for people to find the driver sounds like it's 
trying to cover up shortcomings in our configuration system more than 
anything else.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
