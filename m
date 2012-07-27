Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab2G0PKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 11:10:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41921 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2G0PKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 11:10:43 -0400
Date: Fri, 27 Jul 2012 10:10:38 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH 1/4] EFI: Stash ROMs if they're not in the PCI BAR
Message-ID: <20120727151038.GA13122@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg@redhat.com>, matt.fleming@intel.com,
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-pci@vger.kernel.org, bhelgaas@google.com
References: <1343340169-7772-1-git-send-email-mjg@redhat.com>
 <1343340169-7772-2-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343340169-7772-2-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 06:02:46PM -0400, Matthew Garrett wrote:
> +		rom->data.next = NULL;

Noticed today that I'm getting an "assignment makes integer from pointer
without a cast" warning from this line.

