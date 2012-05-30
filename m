Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2E3VXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:23:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39776 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab2E3VXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:23:47 -0400
Date: Wed, 30 May 2012 17:16:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: William Dauchy <wdauchy@gmail.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/blkback: Copy id field when doing
 BLKIF_DISCARD.
Message-ID: <20120530211639.GB31789@phenom.dumpdata.com>
References: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com>
 <1337982603-15692-2-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1205281119080.26786@kaball-desktop>
 <CAJ75kXZ6gkRF_ZwJ6va860yKT6Vh=mOeUq0YSCKO0ezxjQgqVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ75kXZ6gkRF_ZwJ6va860yKT6Vh=mOeUq0YSCKO0ezxjQgqVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 10:39:10PM +0200, William Dauchy wrote:
> On Mon, May 28, 2012 at 12:19 PM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> >> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=824641
> >> CC: stable@kernel.org
> >> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >
> > Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Tested-by: William Dauchy <wdauchy@gmail.com>

Heh. That is what I get from reading emails in sequence. Thanks!
