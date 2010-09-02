Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab0IBLd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 07:33:59 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:34379 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab0IBLd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 07:33:58 -0400
Subject: Re: [PATCH v2] [arch-x86] Allow SRAT integrity check to be skipped
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        netdev@vger.kernel.org
In-Reply-To: <20100901225937.18457.16372.stgit@localhost.localdomain>
References: <20100901225937.18457.16372.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 13:33:12 +0200
Message-ID: <1283427192.3793.100.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 15:59 -0700, Peter P Waskiewicz Jr wrote:

> +static int srat_bypass_bios;
> +
> +static int __init srat_bypass_bios_setup(char *str)
> +{
> +        srat_bypass_bios = 1;
> +        return 0;
> +}
> +early_param("sratbypassbios", srat_bypass_bios_setup);
> +
>  /* Use the information discovered above to actually set up the nodes. */
>  int __init acpi_scan_nodes(unsigned long start, unsigned long end)
>  {

I wonder, since all the things using the variable are __init, could it
be as well? Just curious really.

johannes

