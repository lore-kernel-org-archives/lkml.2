Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1LHLLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 06:11:02 -0500
Received: from smtp.citrix.com ([66.165.176.89]:27817 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab1LHLLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 06:11:00 -0500
X-IronPort-AV: E=Sophos;i="4.71,319,1320642000"; 
   d="scan'208";a="19774159"
Message-ID: <4EE09B42.4090801@citrix.com>
Date: Thu, 8 Dec 2011 11:10:58 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Bastian Blank <waldi@debian.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 0/4] V2, Move stuff out of xenfs
References: <1323292396-19523-1-git-send-email-waldi@debian.org>	<1323333259.2969.56.camel@zakaz.uk.xensource.com> <20111208092855.GB22678@wavehammer.waldi.eu.org>
In-Reply-To: <20111208092855.GB22678@wavehammer.waldi.eu.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/11 09:28, Bastian Blank wrote:
> On Thu, Dec 08, 2011 at 08:34:19AM +0000, Ian Campbell wrote:
>> How are we doing on the corresponding toolstack changes?
> 
> I have at least parts of it somewhere on my workstation. I'll polish and
> submit them also.

I assume the toolstack will fall back to xenfs if the devices don't exist?

David
