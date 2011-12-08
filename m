Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab1LHIeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:34:21 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:17808 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1LHIeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:34:20 -0500
X-IronPort-AV: E=Sophos;i="4.71,319,1320624000"; 
   d="scan'208";a="9355906"
Subject: Re: [Xen-devel] [PATCH 0/4] V2, Move stuff out of xenfs
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Bastian Blank <waldi@debian.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Date: Thu, 8 Dec 2011 08:34:19 +0000
In-Reply-To: <1323292396-19523-1-git-send-email-waldi@debian.org>
References: <1323292396-19523-1-git-send-email-waldi@debian.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1323333259.2969.56.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-07 at 21:13 +0000, Bastian Blank wrote:
> In <20100605162947.GA31336@wavehammer.waldi.eu.org> I started the
> discussion about xenfs and the usage of it. This is the second try to
> move stuff over into normal device drivers.

I had a few nit picks about error messages but otherwise I'm happy with
this.

How are we doing on the corresponding toolstack changes?

Ian.


