Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab2GMSCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:02:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58984 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab2GMSCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:02:36 -0400
Date: Fri, 13 Jul 2012 19:02:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Runtime updates to EFI secure variables
Message-ID: <20120713180231.GA19355@srcf.ucam.org>
References: <1342199546.3039.30.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342199546.3039.30.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 06:12:26PM +0100, James Bottomley wrote:

> This means (provided we have access to the relevant keys) we can move
> the platform into and out of Setup Mode as well as add signing and other
> keys.

I'm pretty sure that the expected behaviour is to use 
EFI_VARIABLE_APPEND_WRITE for these updates, which means you don't need 
to worry about the timestamp.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
