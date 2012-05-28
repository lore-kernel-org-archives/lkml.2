Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab2E1Jmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:42:44 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34551 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2E1JmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:42:08 -0400
Date: Mon, 28 May 2012 10:44:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 0/13] SATA ZPODD support
Message-ID: <20120528104438.044ae385@pyramind.ukuu.org.uk>
In-Reply-To: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2012 13:08:27 +0800
Lin Ming <ming.m.lin@intel.com> wrote:

> Hi all,
> 
> This is the v4 patches to add SATA ZPODD support, to try it:
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mlin/linux.git zpodd
> 
> Holger and Mathtew,
> Patch 1 to Patch 4 are the libata acpi binding patches from you.
> I removed dock related code from your original version.
> Would you help to review?
> 
> v4:
> - Includes libata acpi binding patches from Holger Macht and Matthew Garrett.
> - tell scsi layer device supports runtime power off
> - check support for device busy class events

Have you fixed the fact that Matthews patches broke things like pata_acpi
last time ? Until that is fixed properly I don't see that these patches
can make any progress.

Alan
