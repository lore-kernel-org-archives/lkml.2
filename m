Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab2CLOLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:11:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46533 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab2CLOLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:11:22 -0400
Date: Mon, 12 Mar 2012 14:11:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Akio Idehara <zbe64533@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Charles@schwieters.org
Subject: Re: [PATCH] toshiba_acpi: Add support for transflective LCD
Message-ID: <20120312141118.GB11375@srcf.ucam.org>
References: <4F3ECEED.9000206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3ECEED.9000206@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any userspace that currently manipulates the bl_power field? 
I'm wondering whether this should actually just be implemented by adding 
an extra level to the backlight and having 0 change to transflective 
mode.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
