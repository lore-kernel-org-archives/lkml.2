Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab2AESVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:21:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35099 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2AESVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:21:52 -0500
Date: Thu, 5 Jan 2012 18:21:49 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Olof Johansson <olof@lixom.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 5/5] x86: efi: allow basic init with mixed 32/64-bit
 efi/kernel
Message-ID: <20120105182149.GB24242@srcf.ucam.org>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
 <1325610682-24811-6-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325610682-24811-6-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems like a reasonable step, but outside some special cases it's 
not going to be terribly useful - general purpose EFI machines aren't 
going to boot unless you can set the boot variable, which requires 
runtime services. ChromeOS machines presumably have their own way of 
handling this so I've no objection to adding it if it helps them, but 
just wanted to make sure people knew that it's something that we'd still 
need to fix up if we want this to work elsewhere.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
