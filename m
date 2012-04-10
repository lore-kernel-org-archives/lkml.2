Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab2DJQnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:43:22 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37226 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2DJQnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:43:20 -0400
Date: Tue, 10 Apr 2012 09:43:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] staging: octeon_ethernet: Convert to use device tree.
Message-ID: <20120410164316.GA15131@kroah.com>
References: <1332808075-8333-1-git-send-email-ddaney.cavm@gmail.com>
 <1332808075-8333-5-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332808075-8333-5-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 05:27:54PM -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Get MAC address and PHY connection from the device tree.  The driver
> is converted to a platform driver.
> 
> Cc: netdev@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
> 
> Should probably go via Ralf's linux-mips.org tree.

That's fine with me:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

