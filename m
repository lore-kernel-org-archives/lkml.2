Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab1I3IqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:46:08 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.102]:58370 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab1I3IqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:46:06 -0400
Message-ID: <4E858200.8070302@ladisch.de>
Date: Fri, 30 Sep 2011 10:46:56 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: markh@compro.net
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: Problem with AMD chipsets. Was "Re: problems doing direct dma
 from a pci device to pci-e device"
References: <4E84CA01.2060907@compro.net> <4E84D55A.5050406@compro.net>
In-Reply-To: <4E84D55A.5050406@compro.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> We have no problem with this same configuration using a MB with an
> nvidia chipset. I suspect it might have something to do with the the MB
> that usines the AMD chipset having an IOMMU, but I really don't know for
> sure. I've also read something in the AMD chipset docs about some type
> of restrictions on peer to peer transfers but again I really have no
> idea if this is related to why I'm having this problem.

According to the published RS780 docs, "P2P traffic could be only memory
writes" (RPR 2.7).  In any case, check the P2P bits (MISC is described
in BDG 2.4).


Regards,
Clemens
