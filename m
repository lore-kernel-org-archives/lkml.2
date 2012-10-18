Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab2JRS2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:28:44 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43047 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2JRS2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:28:43 -0400
Date: Thu, 18 Oct 2012 19:28:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Daniel Vacek <neelx.g@gmail.com>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] efi: Build EFI stub with EFI-appropriate options
Message-ID: <20121018182831.GA30905@srcf.ucam.org>
References: <1343340000-7587-1-git-send-email-mjg@redhat.com>
 <CAA7rmPGL827cgT6hM8h_xhokEbTbTnrptoRekVByM7AcMdRUdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA7rmPGL827cgT6hM8h_xhokEbTbTnrptoRekVByM7AcMdRUdw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 08:18:51PM +0200, Daniel Vacek wrote:

> s/CLFAGS/CFLAGS/
> 
> should go to stable too?

Crap. Yes. Feel free to send that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
