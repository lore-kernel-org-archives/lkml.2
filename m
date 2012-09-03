Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab2ICD0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 23:26:55 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44076 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2ICD0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 23:26:54 -0400
Date: Mon, 3 Sep 2012 04:26:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: [RFC,PATCH] efi: Add support for a UEFI variable filesystem
Message-ID: <20120903032642.GA21904@srcf.ucam.org>
References: <1346319009.951368.767015086462.1.gpush@pecola>
 <503FA15F.7070506@zytor.com>
 <50400859.2080606@canonical.com>
 <5e40036f-b0da-47f3-acba-5dea9fdb7ed6@email.android.com>
 <50440A5A.900@canonical.com>
 <9741b1ed-c285-4f89-b60d-337140194345@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9741b1ed-c285-4f89-b60d-337140194345@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2012 at 06:59:37PM -0700, H. Peter Anvin wrote:
> Well, appending is an action, not really a property of the variable that sticks around, no?

We could do this for append, but what happens if an attribute with 
similar variables appears and doesn't neatly map to an O_ option? We 
can't really argue for limiting attributes purely because they don't map 
neatly onto POSIX semantics...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
