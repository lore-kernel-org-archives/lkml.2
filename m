Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1LUS2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:28:25 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51304 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1LUS2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:28:21 -0500
Date: Wed, 21 Dec 2011 18:28:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: HP Envy 17 3D BIOS reports "Thermal Shutdown" on every reboot
 despite no thermal problems
Message-ID: <20111221182817.GA25036@srcf.ucam.org>
References: <CAGZ=bqKqO328BQa7+0S-GNfmvgKurcB1Z66qbCMT7Fu3G=7Leg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGZ=bqKqO328BQa7+0S-GNfmvgKurcB1Z66qbCMT7Fu3G=7Leg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try the patch I sent entitled "[PATCH] ACPI: Evaluate thermal trip 
points before reading temperature".

-- 
Matthew Garrett | mjg59@srcf.ucam.org
