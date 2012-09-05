Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612Ab2IEVlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:41:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60516 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2IEVlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:41:47 -0400
Date: Wed, 5 Sep 2012 22:41:42 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
Message-ID: <20120905214142.GA29288@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-8-git-send-email-mjg@redhat.com>
 <1346879629.2054.22.camel@falcor.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346879629.2054.22.camel@falcor.watson.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:13:49PM -0400, Mimi Zohar wrote:

> Normally capabilities provide additional permissions. So if you don't
> have the capability, an errno is returned.  CAP_SYS_BOOT is a good
> example.  With CAP_SECURE_FIRMWARE, it reads backwards - if not
> CAP_SECURE_FIRMWARE, return error.  I think you want to invert the name
> to CAP_NOT_SECURE_FIRMWARE, CAP_NOT_SECURE_BOOT or perhaps
> CAP_UNSECURED_BOOT.

Yeah, I think renaming the cap is a given.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
