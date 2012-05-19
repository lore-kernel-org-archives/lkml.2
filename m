Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2ESGHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:07:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36532 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab2ESGHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:07:30 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 4/5] staging: octeon_ethernet: Convert to use device tree.
To: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1335489630-27017-5-git-send-email-ddaney.cavm@gmail.com>
References: <1335489630-27017-1-git-send-email-ddaney.cavm@gmail.com> <1335489630-27017-5-git-send-email-ddaney.cavm@gmail.com>
Date: Sat, 19 May 2012 00:07:27 -0600
Message-Id: <20120519060727.C455D3E046E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012 18:20:29 -0700, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Get MAC address and PHY connection from the device tree.  The driver
> is converted to a platform driver.
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: David Daney <david.daney@cavium.com>
> Cc: netdev@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: David S. Miller <davem@davemloft.net>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

