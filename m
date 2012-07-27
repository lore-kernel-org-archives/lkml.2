Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2G0D7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 23:59:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39263 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2G0D7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 23:59:47 -0400
Date: Thu, 26 Jul 2012 22:59:40 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: efi, x86, pci: Improve graphics support on some Apple hardware
Message-ID: <20120727035940.GA7119@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>, matt.fleming@intel.com,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-pci@vger.kernel.org, bhelgaas@google.com
References: <1343340169-7772-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343340169-7772-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 06:02:45PM -0400, Matthew Garrett wrote:
> Some Apple machines only provide their video ROM via an EFI-specific mechanism
> and don't permit it to be retrieved from the BAR. Add infrastructure to stash
> it and provide access to drivers.

I've verified that these patches produce funtioning radeon graphics on
both the Macbook Pro 8,2 and Mac Mini 5,2 under native EFI boot.
Previously the radeon driver did not work on these machines due to
failure to locate the video ROM. So for the whole series:

Tested-by: Seth Forshee <seth.forshee@canonical.com>

