Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab1BWOlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 09:41:14 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:33595 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1BWOlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 09:41:13 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Feb 2011 09:41:13 EST
Date: Wed, 23 Feb 2011 15:30:28 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Gibson <david@gibson.dropbear.id.au>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/10] MIPS: Octeon: Add device tree source files.
Message-ID: <20110223143028.GA11832@linux-mips.org>
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
 <1298408274-20856-3-git-send-email-ddaney@caviumnetworks.com>
 <20110223000759.GA26300@yookeroo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223000759.GA26300@yookeroo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 11:07:59AM +1100, David Gibson wrote:

> Uh.. where are the CPUs?

CPUs are probed the old style way on MIPS.  There is a large number of
varieties of CPUs - things like cache size, cache line size, architectural
extension and many small details of behaviour differ.  If we'd fully
honor DT CPU configuration information a kernel would need to have fairly
full blown generic CPU support for anything under the sun.  But there
already is a scheme that allows platform support code to select permanet
enablement, disablement or runtime probe for every CPU feature under the
sun for significant code savings and performance gain.

  Ralf
