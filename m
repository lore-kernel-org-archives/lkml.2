Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2AOVyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 16:54:43 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56794 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463Ab2AOVyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 16:54:41 -0500
X-Sasl-enc: eTHPyQpeyMqyw1Rex2IJIcbK9T7xNDFlV+4LUdfv+IpS 1326664480
Date: Sun, 15 Jan 2012 13:52:37 -0800
From: Greg KH <greg@kroah.com>
To: Kurt Garloff <kurt@garloff.de>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 1/3]: Store SRAT revision
Message-ID: <20120115215237.GA10124@kroah.com>
References: <20120115213005.GT12380@tpkurt2.garloff.de>
 <20120115213407.GU12380@tpkurt2.garloff.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120115213407.GU12380@tpkurt2.garloff.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 10:34:07PM +0100, Kurt Garloff wrote:
> Hi,
> 
> This patch stores the SRAT table revision for later consumption
> by arch specific __init functions.
> 
> 
> This is patch 1/3.
> -- 
> Kurt Garloff <kurt@garloff.de>  [Koeln/Greven]
> 

> From: Kurt Garloff <kurt@garloff.de>
> Subject: Store SRAT table revision
> References: bnc#503038
> 
> In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
> 32bits for these. The new fields were reserved before.
> According to the ACPI spec, the OS must disregrard reserved fields.
> In order to know whether or not, we must know what version the SRAT
> table has.
> 
> This patch stores the SRAT table revision for later consumption
> by arch specific __init functions.
> 
> This is patch 1/3.
> 
> Signed-off-by: Kurt Garloff <kurt@garloff.de>
> 
> ---
>  drivers/acpi/numa.c      |    3 +++
>  include/acpi/acpi_numa.h |    1 +
>  2 files changed, 4 insertions(+)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
