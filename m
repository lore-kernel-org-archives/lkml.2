Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab1LNTvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:51:17 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33084 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab1LNTvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:51:16 -0500
Date: Wed, 14 Dec 2011 19:51:11 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 1/5] drivers: power: Rename bq20z75 to sbs-battery
Message-ID: <20111214195111.GA26795@srcf.ucam.org>
References: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
 <20111206174100.GA15449@srcf.ucam.org>
 <1323890766.8326.2.camel@rklein-linux2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323890766.8326.2.camel@rklein-linux2>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They're both i2c, so really all that ought to be different would be the 
glue to trigger the device probe. In theory. We'll see how well it works 
in practice...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
