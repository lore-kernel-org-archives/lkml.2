Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1DDMWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 08:22:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58487 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab1DDMWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:22:38 -0400
Date: Mon, 4 Apr 2011 13:22:25 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: linux-next: Tree for April 4 [BROKEN thinkpad_acpi]
Message-ID: <20110404122225.GA15883@srcf.ucam.org>
References: <BANLkTikr62YPeDnkL3DKA1Nts5aRFxsO6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikr62YPeDnkL3DKA1Nts5aRFxsO6Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 11:21:43AM +0200, Sedat Dilek wrote:
> My build breaked today.
> Looks like the issue was introduced by commit
> 2af915b1eda9a671973256540035f8a6da1d57b4:
> "thinkpad_acpi: Convert printks to pr_<level>"

Yes, this seems to break the non-debug case. Joe, can you take a look? 
I'll drop this for the moment.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
