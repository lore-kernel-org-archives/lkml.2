Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab0JDR2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:28:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45054 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab0JDR2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:28:12 -0400
Date: Mon, 4 Oct 2010 18:28:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Daniel Drake <dsd@laptop.org>
Cc: dilinger@queued.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add OLPC XO-1 rfkill driver
Message-ID: <20101004172807.GA10189@srcf.ucam.org>
References: <20101004171520.4B0189D401B@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101004171520.4B0189D401B@zog.reactivated.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 06:15:20PM +0100, Daniel Drake wrote:
> +static int __devinit xo1_rfkill_probe(struct platform_device *pdev)
> +{
> +	struct rfkill *rfk;
> +	int r;
> +
> +	printk(KERN_INFO "%s: loading\n", pdev->name);

Probably don't need this. Otherwise, looks fine.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
