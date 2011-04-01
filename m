Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab1DARW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 13:22:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42354 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab1DARWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 13:22:55 -0400
Date: Fri, 1 Apr 2011 18:22:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Cc: anssi.hannula@iki.fi, linux-acpi@vger.kernel.org, axel.lin@gmail.com,
        trenn@suse.de, len.brown@intel.com, error27@gmail.com,
        malattia@linux.it, linux-kernel@vger.kernel.org
Subject: Re: Regression 2.6.39-rc1 for sony-laptop
Message-ID: <20110401172241.GA26851@srcf.ucam.org>
References: <AANLkTi=1xtjEZc2C1=W-v2oYbvvcGH9k_DGGXvJ8=swq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=1xtjEZc2C1=W-v2oYbvvcGH9k_DGGXvJ8=swq@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 07:16:43PM +0200, Andrea Gelmini wrote:

> Git bisect blames this commit:

Pretty convinced that git bisect's got that wrong, given that it doesn't 
touch any Sony code. I'll take a look at the Sony patches, thanks for 
the report!

-- 
Matthew Garrett | mjg59@srcf.ucam.org
