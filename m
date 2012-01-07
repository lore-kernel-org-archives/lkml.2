Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab2AGV01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 16:26:27 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:56291 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2AGV0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 16:26:22 -0500
Date: Sat, 7 Jan 2012 21:26:14 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: Thomas Renninger <trenn@suse.de>, linux-acpi@vger.kernel.org,
        Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] ACPI: EC: Add ec_get_handle()
Message-ID: <20120107212614.GA24097@srcf.ucam.org>
References: <1325617358-8286-1-git-send-email-seth.forshee@canonical.com>
 <1325617358-8286-2-git-send-email-seth.forshee@canonical.com>
 <CAPbh3ruqMQ8UFSehm7vX5i8YWzRFwF5=TX_f4n4dVkvmQa9Njw@mail.gmail.com>
 <20120105193436.GC25386@ubuntu-macmini>
 <CAPbh3rv86E9zqUbF4vrA2G=FaXyNHqD7+NZXRkzrzYAsHL8a_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPbh3rv86E9zqUbF4vrA2G=FaXyNHqD7+NZXRkzrzYAsHL8a_Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 07, 2012 at 03:55:35PM -0500, Konrad Rzeszutek Wilk wrote:

> My understanding (and this is from reading Greg KH's patches) is that
> any new interface should use _GPL variant unless there is an absolute
> need for it. Say, a binary driver that uses this function and there is
> no other way around it.

A binary driver could implement the same functionality using exported 
interfaces from the ACPI core, so I don't see any benefit in insisting 
on _GPL here. _GPL is intended to be a hint that use of the interface is 
definitely an indication that you're creating a derived work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
