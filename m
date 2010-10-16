Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab0JPGkf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 02:40:35 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:43426 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab0JPGkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 02:40:33 -0400
Date: Sat, 16 Oct 2010 08:40:18 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Seth Heasley <seth.heasley@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 2.6.35.4] irq: irq and pci_ids patch for Intel Patsburg
Message-ID: <20101016084018.58671452@endymion.delvare>
In-Reply-To: <20101015125428.01120a8d@jbarnes-desktop>
References: <201009241606.11840.seth.heasley@intel.com>
	<201010041327.15170.seth.heasley@intel.com>
	<20101015125428.01120a8d@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 12:54:28 -0700, Jesse Barnes wrote:
> On Mon, 4 Oct 2010 13:27:14 -0700
> Seth Heasley <seth.heasley@intel.com> wrote:
> > This patch updates the defines for Intel devices in include/linux/pci_ids.h, referenced in arch/x86/pci/irq.c and drivers/i2c/busses/i2c-i801.c, reflecting approved legal branding, and using fuller code-names for products under development.
> >  
> > Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> Applied this update, thanks.
> 
> Note that going forward I don't expect (or want!) patches to convert
> the development names into marketing names.  We should just add new
> stuff with the development names (before the product ships) and leave
> them that way to avoid unnecessary churn.

Fine with me, as long as it is the actual names and not obscure
3-letter shortcuts.

-- 
Jean Delvare
