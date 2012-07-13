Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161091Ab2GMRup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 13:50:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41667 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2GMRuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 13:50:39 -0400
Date: Fri, 13 Jul 2012 18:50:36 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, mikew@google.com,
        keescook@chromium.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v2] Add missing attributes to EFI variable attribute
 print out from sysfs
Message-ID: <20120713175036.GB18496@srcf.ucam.org>
References: <20120713174216.GA10445@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713174216.GA10445@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 11:42:16AM -0600, Khalid Aziz wrote:
> Some of the EFI variable attributes are missing from print out from
> /sys/firmware/efi/vars/*/attributes. This patch adds those in. It also
> updates code to use pre-defined constants for masking current value
> of attributes.
> 
> Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
> Cc: stable@vger.kernel.org
Acked-by: Matthew Garrett <mjg@redhat.com>
-- 
Matthew Garrett | mjg59@srcf.ucam.org
