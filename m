Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab0IFUNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 16:13:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab0IFUNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 16:13:25 -0400
Date: Mon, 6 Sep 2010 16:13:11 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Tejun Heo <tj@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, jgarzik@redhat.com,
        linux-kernel@vger.kernel.org,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: libata acpi issue on gateway laptop
Message-ID: <20100906201310.GO2684@bombadil.infradead.org>
References: <20100906193501.GM2684@bombadil.infradead.org>
 <4C854502.8040009@kernel.org>
 <20100906195108.GN2684@bombadil.infradead.org>
 <4C854987.6070406@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C854987.6070406@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 10:05:27PM +0200, Tejun Heo wrote:
> Hmm... I don't see any timeout in the log you posted.  Ah, okay, the
> interesting part is in the full log, the ACPI GTF sequence itself is
> finishing fine but the next NCQ READ command is timing out.  The BIOS
> is enabling non-zero buffer offsets and DMA setup FIS auto-activate.
> It's likely that the controller isn't being configured correctly
> leading to mismatch between the behavior expected by the controller
> and the actual drive behavior.  Hmm.... I'll look further into it
> tomorrow.  For the record, can you please attach the full log, lspci
> -nn output and dmidecode output here?
> 

Thanks Tejun, I've requested this from the original reporter, and I'll
attach it here when I hear back.

(Oops, sorry for fudging linux-ide->linux-ata, thanks for fixing that.)

regards, Kyle
