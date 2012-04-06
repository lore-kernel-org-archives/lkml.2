Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab2DFVGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 17:06:06 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17376 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab2DFVGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 17:06:04 -0400
Date: Fri, 6 Apr 2012 17:01:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 6/7] xen/setup: Make dom0_mem=XGB behavior be
 similar to classic Xen kernels.
Message-ID: <20120406210117.GB26309@phenom.dumpdata.com>
References: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
 <1333139850-28456-7-git-send-email-konrad.wilk@oracle.com>
 <4F7ABBC4.4050106@citrix.com>
 <4F7AE321020000780007C456@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7AE321020000780007C456@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F7F5AB6.0099,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 10:46:41AM +0100, Jan Beulich wrote:
> >>> On 03.04.12 at 10:58, David Vrabel <david.vrabel@citrix.com> wrote:
> > With your new behaviour it will no longer possible to specify an
> > unlimited balloon but a limited number of initial pages.  This is
> > behaviour that Jan said he used.
> 
> An unlimited balloon was never possible afaict (as that would have
> implied setting up an "infinite" number of struct page instances at
> boot time.
> 
> What I'm using is "dom0_mem=-<num>M" together with the kernel
> option "mem=<num>G", such that max-balloon > initial alloc (usually
> I set max-balloon to approximately the amount of memory in the
> system, so the upper limit is "infinite" in the sense that I can't go
> higher anyway, but it's not truly infinity).

Couldn't you do the same thing with 'dom0_mem=X,max:Y'
> 
> Jan
