Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0FGNEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 09:04:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57734 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0FGNE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 09:04:29 -0400
Date: Mon, 7 Jun 2010 14:04:19 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Robert Hancock <hancockrwd@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, garzik@redhat.com
Subject: Re: Hang during boot, bisected to commit 96d60303fd
Message-ID: <20100607130419.GA8661@srcf.ucam.org>
References: <AANLkTiktNufXK_pn6mP2-zyowAIbHlUy5TGu3AtpALv-@mail.gmail.com> <20100603020006.GB19123@srcf.ucam.org> <AANLkTikpv86r5BBPCEOHujpm8uCgY0DxghSKjBufBWiM@mail.gmail.com> <4C08760B.8050002@gmail.com> <AANLkTimFY5YQv8DC-zTQ1RF84rno6svvcyLzHGWL6HOk@mail.gmail.com> <AANLkTimXcF1pafrSt8dMbUs59AjnqaRwpzDnPIPjdjsn@mail.gmail.com> <AANLkTinZ7d3WWyO3m9A7GVnaTuSbn1G33ADFW6ixywcT@mail.gmail.com> <AANLkTinIM8swHZTide7MAQsaYbWcFD90FrKUXE9NFG-5@mail.gmail.com> <4C0CBA5D.5000900@kernel.org> <AANLkTilwtazg_T4cX2EMb2xterwV1lhXdqUe3Q1UcsDN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilwtazg_T4cX2EMb2xterwV1lhXdqUe3Q1UcsDN@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 08:21:42AM -0400, Marc Dionne wrote:

> With that patch the system boots normally.  Out of curiosity I also
> instrumented ahci_error_handler a bit, and the stop_engine case
> triggers once for the 6 unused ports, but doesn't trigger for the 2
> ports with devices (SSD and DVD), as expected.
> 
> Feel free to add a Tested-by if you submit it.

Well, that's what trusting the ahci spec gets me. Thanks for testing 
that, Marc.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
