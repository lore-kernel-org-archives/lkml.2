Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab2COHna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 03:43:30 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:62732 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2COHn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 03:43:28 -0400
X-IronPort-AV: E=Sophos;i="4.73,589,1325462400"; 
   d="scan'208";a="11308864"
Message-ID: <1331797406.13956.20.camel@dagon.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] xen/blkback: Squash the discard support for
 'file' and 'phy' type.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Li Dongyang <lidongyang@novell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Date: Thu, 15 Mar 2012 07:43:26 +0000
In-Reply-To: <20120314202352.GC6251@phenom.dumpdata.com>
References: <1331679128-27646-1-git-send-email-konrad.wilk@oracle.com>
	 <1331714035.4092.4.camel@dagon.hellion.org.uk>
	 <20120314202352.GC6251@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-14 at 20:23 +0000, Konrad Rzeszutek Wilk wrote:
> On Wed, Mar 14, 2012 at 08:33:55AM +0000, Ian Campbell wrote:
> > On Tue, 2012-03-13 at 22:52 +0000, Konrad Rzeszutek Wilk wrote:
> > > The only reason for the distinction was for the special case of
> > > 'file' (which is assumed to be loopback device)
> > 
> > Not related to this patch but how feasible would it be to make blkback
> > able to cope with files directly?
> 
> Intersting thought. I am not sure... but an interesting thought. Would you
> have Daniel's private email? We could email him for thoughts.

I'm afraid I don't have any contact info for Daniel these days.

Ian.


