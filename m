Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934584Ab0HDUOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:14:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41687 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934547Ab0HDUOq (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 16:14:46 -0400
Date: Wed, 4 Aug 2010 16:14:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com
Subject: Re: [Xen-devel] [RFC PATCH] Xen PCI frontend driver (v0.5)
Message-ID: <20100804201402.GA18384@phenom.dumpdata.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C59CA28.029C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 02:18:55PM -0400, Konrad Rzeszutek Wilk wrote:
> This patch set contains the groundwork and the driver itself for
> Xen Paravirtualized (PV) domains to use PCI pass-through devices.
> 
> These patches utilize the Xen-SWIOTLB library
> (http://lkml.org/lkml/2010/7/27/246) and I don't expect them to
> get in the 2.6.36 merge window.

<sigh>And when I say "them", I mean "this". Meaning this set of patches that
introduce the Xen PCI frontend driver. 

Sorry about the confusion.
