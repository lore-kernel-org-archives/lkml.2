Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab0KPPyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:54:05 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:36508 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab0KPPyE (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 16 Nov 2010 10:54:04 -0500
Date: Tue, 16 Nov 2010 10:52:58 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>,
        Stephen Tweedie <sct@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 1/3] xen dom0: Add support for the
 platform_ops hypercall
Message-ID: <20101116155258.GB6535@dumpdata.com>
References: <cover.1289519130.git.jeremy.fitzhardinge@citrix.com>
 <0aa82d86c699890ce3661927f176045fc8e47156.1289519130.git.jeremy.fitzhardinge@citrix.com>
 <20101115154814.GB345@dumpdata.com>
 <4CE1DB0F.8030808@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE1DB0F.8030808@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Why not just introduce the one we are using (just one right now)
> > and on subsequent patches that enable the functionality add it in this file?
> 
> The main reason is that if some other branch also brings in platform.h
> then its easier to merge two copies of the same file rather than two
> subsets.

Sure, but in linux-next that is just one touch patch and Stephen said
he is Ok with those.

I like doing it (just stick in those that we use), b/c that way you have
an excellent view of when this feature went in the code and the relevant
git commits to blame.
