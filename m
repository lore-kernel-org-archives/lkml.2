Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab2FGRFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:05:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338Ab2FGRFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:05:49 -0400
Message-ID: <1339088741.26976.19.camel@ul30vt>
Subject: Re: [PATCH] PCI: Add Ralink RT2800 broken INTx masking quirk
From: Alex Williamson <alex.williamson@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Thu, 07 Jun 2012 11:05:41 -0600
In-Reply-To: <4FD047A7.6050602@01019freenet.de>
References: <20120606212241.6627.98371.stgit@bling.home>
	 <4FD047A7.6050602@01019freenet.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 08:18 +0200, Andreas Hartmann wrote:
> Hello Alex,
> 
> what about a module parameter to achieve this behaviour manually by
> the user without recompiling? I fear, there are much more candidates
> out there needing this "feature".

Yeah, that's probably a good idea.  For debugging and letting users have
a workaround rather than any kind of regular use.  I'll add a nointxmask
to vfio-pci with a description indicating that if it fixes a device to
report it for quirking.  Thanks,

Alex

