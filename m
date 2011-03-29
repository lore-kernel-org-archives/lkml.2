Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1C2NrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:47:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59936 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1C2NrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:47:16 -0400
Date: Tue, 29 Mar 2011 14:47:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] eeepc-wmi: Add support for T101MT Home/Express
 Gate key
Message-ID: <20110329134702.GA13630@srcf.ucam.org>
References: <AANLkTi=U2Qkqv7FKfe18f0a=8Xg0QwRX_cxFj-j7ZPC=@mail.gmail.com>
 <1301337224-3293-1-git-send-email-seth.forshee@canonical.com>
 <1301337224-3293-3-git-send-email-seth.forshee@canonical.com>
 <AANLkTi=QJzVt=tR2mUmaRwvhNz5eeV0BE1LB0-pCybNV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=QJzVt=tR2mUmaRwvhNz5eeV0BE1LB0-pCybNV@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 12:29:11PM +0000, Corentin Chary wrote:

> I think this version is ok,
> 
> Matthew, do you think this should be delayed for 2.6.40 (merge window
> will close soon, so now it's probably time for fix only) ?

Yeah, I'd lean towards this being .40 material.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
