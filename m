Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1ADQpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:45:40 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35226 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1ADQpj (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 4 Jan 2011 11:45:39 -0500
Date: Tue, 4 Jan 2011 11:45:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Jan Beulich <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 1/8] xen: Mark all initial reserved pages for the
 balloon as INVALID_P2M_ENTRY.
Message-ID: <20110104164521.GA7543@dumpdata.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
 <1293738517-7287-2-git-send-email-konrad.wilk@oracle.com>
 <1294158888.3831.509.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294158888.3831.509.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 04:34:48PM +0000, Ian Campbell wrote:
> On Thu, 2010-12-30 at 19:48 +0000, Konrad Rzeszutek Wilk wrote:
> > With this patch, we diligently set regions that will be used by the
> > balloon driver to be INVALID_P2M_ENTRY and under the ownership
> > of the balloon driver. We are OK using the __set_phys_to_machine
> > as we do not expect to be allocating any P2M middle or entries pages.
> 
> ... because xen_build_mfn_list_list will have already allocated all such
> pages up to xen_max_p2m_pfn.

Correct. Let me update the description accordingly.
