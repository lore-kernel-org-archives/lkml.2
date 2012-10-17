Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2JQRz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:55:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28036 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab2JQRz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:55:27 -0400
Date: Wed, 17 Oct 2012 13:43:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ben Guthro <ben@guthro.net>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org, hpa@zytor.com,
        x86@kernel.org
Subject: Re: [RFC] ACPI S3 and Xen (suprisingly small\!).
Message-ID: <20121017174317.GA25443@phenom.dumpdata.com>
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>
 <CAOvdn6WBj_-=3Z=ZrD670Zup4H=pvjXknvHGgjs55k3LWJyDxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOvdn6WBj_-=3Z=ZrD670Zup4H=pvjXknvHGgjs55k3LWJyDxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 01:46:09PM -0400, Ben Guthro wrote:
> On Wed, Oct 17, 2012 at 9:49 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> [...]
> 
> > The end result is this is a nice set of patches where there is only
> > _one_ change in the x86 code (and it is just more of dealing with
> > error case) - and the rest are all done in Xen side.
> 
> I'm sorry to report that this series doesn't seem to work in my setup
> against xen-unstable.
> 
> To verify that it was, in fact this patch series, and not another Xen
> regression - I swapped out the kernel with this patch series, with an
> identical one, replacing only this series with your acpi-s3.v9 branch
> - and everything worked fine.

Thanks for testing it!

I had tested it with Xen 4.1.3, which could be doing something different.
Will see what is up.
