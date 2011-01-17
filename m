Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab1AQR4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 12:56:03 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47313 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1AQR4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 12:56:00 -0500
Date: Mon, 17 Jan 2011 17:55:55 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] toshiba_acpi: Additional TOS1900 devices support
Message-ID: <20110117175555.GA30554@srcf.ucam.org>
References: <AANLkTi=fjL0yxXWrDddafdBs7biJ326sXjaagTseVEVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=fjL0yxXWrDddafdBs7biJ326sXjaagTseVEVg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this needs to be tidied up some more to interact nicely with the 
ec driver, and I'm still a bit concerned that there may be devices of 
the TOS1900 type that implement the old-syle interface but not this one 
(I'll check the files I have here). I'll try to break this up into 
something more generic.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
