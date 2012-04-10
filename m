Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036Ab2DJPrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:47:00 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:29391 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2DJPq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:46:59 -0400
X-IronPort-AV: E=Sophos;i="4.75,399,1330905600"; 
   d="scan'208";a="11860959"
Date: Tue, 10 Apr 2012 16:50:25 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jan Beulich <JBeulich@suse.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, xen-devel <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-blkfront: properly name all devices
In-Reply-To: <4F7DD852020000780007CC2A@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.00.1204101645000.15151@kaball-desktop>
References: <4F7DD852020000780007CC2A@nat28.tlf.novell.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2012, Jan Beulich wrote:
> - devices beyond xvdzz didn't get proper names assigned at all
> - extended devices with minors not representable within the kernel's
>   major/minor bit split spilled into foreign majors
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

The patch is OK.

Would you be up for writing a couple of lines under Documentation to
clearly state what device names are going to be given by blkfront in
correspondence to vdev numbers?
