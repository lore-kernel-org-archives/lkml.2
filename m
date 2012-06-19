Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2FSKkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:40:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:49618 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab2FSKki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:40:38 -0400
Message-ID: <1340102401.28143.12.camel@pasglop>
Subject: Re: [PATCH v2 0/7] IOMMU: Groups support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, bhelgaas@google.com,
        david@gibson.dropbear.id.au, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, ddutile@redhat.com, liuj97@gmail.com
Date: Tue, 19 Jun 2012 20:40:01 +1000
In-Reply-To: <20120619094918.GH2624@amd.com>
References: <20120530201424.31527.33142.stgit@bling.home>
	 <20120606110514.GG757@amd.com> <1339429021.24037.8.camel@bling.home>
	 <1340040703.17272.2.camel@bling.home> <20120619094918.GH2624@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 11:49 +0200, Joerg Roedel wrote:
> Well, we can't hold up things forever. Given that the POWER guys had
> long discussions with you about previous versions but not about this one
> counts as a silent Ack for me ;)

Everybody was waiting for me and I was out for 3 weeks following some
surgery ... I'll review that stuff ASAP (as in tomorrow if I can, else
before end of the week).

> So I already applied the patches into my local tree yesterday and gave
> them some additional testing. All looks good so far. I think I will push
> the result soon to get this into linux-next.
> 
> I'll probably rebase to add the Cc's to the commits before pushing it
> out.

Cheers,
Ben.


