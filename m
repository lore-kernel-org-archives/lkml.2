Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab0LFXfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:35:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46902 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab0LFXfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 18:35:03 -0500
Date: Mon, 6 Dec 2010 23:34:58 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: unsigned commits
Message-ID: <20101206233458.GA3738@srcf.ucam.org>
References: <20101207103346.fbbcf099.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101207103346.fbbcf099.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 10:33:46AM +1100, Stephen Rothwell wrote:
> Hi Matthew,
> 
> Looking through the drivers-x86 tree update for linux-next today, I found
> a few commits that have no signed-off-by line ...
> 
> 8f2e88b22a4caaebcc8d5a9e00a8249fec350cf3	"Generic key reporting"
> e3a2b10707902bcf95d022a5bab8f13b26bccc64	"ACPI-ify"
> 52f4e59f269e0d3bb1d54ca654d9cbf6880e7370	"Fix some tos1900 devices"
> 64ea4efdd949c99d9206a44a43984d2e861350f1	"wwan rfkill stubs"
> 
> And I think those commit messages could do with some elaboration as well.

They're somewhat WIP - I'll shift them to a topic branch.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
