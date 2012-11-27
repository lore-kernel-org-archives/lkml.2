Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab2K0Xam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:30:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44875 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2K0Xah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:30:37 -0500
Date: Tue, 27 Nov 2012 15:30:29 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]:  PVH: remove FEATURES_PVH macro
Message-ID: <20121127153029.7296ea69@mantra.us.oracle.com>
In-Reply-To: <20121126195400.GA8025@phenom.dumpdata.com>
References: <20121114181933.1ffb5f09@mantra.us.oracle.com>
	<20121126195400.GA8025@phenom.dumpdata.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2012 14:54:00 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Wed, Nov 14, 2012 at 06:19:33PM -0800, Mukesh Rathor wrote:
> > PVH: remove macro FEATURES_PVH and put PVH strings in the ELFNOTE
> > line, because there's a null char before FEATURES_PVH and in the
> > FEATURES_PVH strings since this is not C file
> 
> ping? Jan had a comment about it to keep the #ifdef at the top
> and combine ascii and asiz?

Ok, if you'd like that too, I'll look into it. I need to RTFM.

thanks
Mukesh
