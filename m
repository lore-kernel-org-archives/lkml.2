Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0J1Lx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:53:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:23495 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab0J1Lx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:53:56 -0400
X-IronPort-AV: E=Sophos;i="4.58,251,1286164800"; 
   d="scan'208";a="10848821"
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Borislav Petkov <bp@alien8.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <20101028112052.GA21757@a1.tnic>
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com>
	 <20101027104020.GA16954@a1.tnic> <4CC85839.4000507@goop.org>
	 <4CC85EE6.7030608@linux.intel.com> <4CC861F9.8080200@goop.org>
	 <20101027174417.GA19194@a1.tnic>
	 <1288202321.10179.102.camel@localhost.localdomain>
	 <1288257797.8361.1545.camel@zakaz.uk.xensource.com>
	 <20101028112052.GA21757@a1.tnic>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 28 Oct 2010 12:53:52 +0100
Message-ID: <1288266832.1228.99.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 12:20 +0100, Borislav Petkov wrote:
> On Thu, Oct 28, 2010 at 10:23:17AM +0100, Ian Campbell wrote:
> > Now tested and it works. Patch below.
> 
> I'm assuming you tested bare metal too?

Yes, I tried PAE with and without CONFIG_PARAVIRT as well as non-PAE
without CONFIG_PARAVIRT.

Ian.


