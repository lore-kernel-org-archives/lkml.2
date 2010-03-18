Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0CRH1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 03:27:53 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45724 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011Ab0CRH1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 03:27:52 -0400
X-Sasl-enc: GPcpjpNdUw989b7sEvuRvcaHbGgfEcHtnq8gKgU8iMXb 1268897271
Message-ID: <4BA1D5F4.7070304@ladisch.de>
Date: Thu, 18 Mar 2010 08:27:48 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: linux-acpi@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       linux-kernel@vger.kernel.org,
       "Venkatesh Pallipadi (Venki)" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 2/3] hpet: pass physical address, not entire hpet_data,
 to hpet_is_known()
References: <20100317173329.31124.69795.stgit@bob.kio> <20100317173505.31124.74595.stgit@bob.kio>
In-Reply-To: <20100317173505.31124.74595.stgit@bob.kio>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> No functional change; hpet_is_known() only needs the physical address,
> so supplying that instead of the whole struct hpet_data makes the callers
> a little simpler.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Acked-by: Clemens Ladisch <clemens@ladisch.de>
