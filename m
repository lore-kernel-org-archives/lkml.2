Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab0HDSX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:23:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758339Ab0HDSXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:23:53 -0400
Date: Wed, 4 Aug 2010 11:23:18 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/6] staging: hv: Fixed bounce kmap problem by using
 correct index
Message-ID: <20100804182318.GB29046@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56223FD0D21@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100803173732.GA1455@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56223FE8B19@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100804170406.GA28217@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56223FE8EF5@TK5EX14MBXC114.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56223FE8EF5@TK5EX14MBXC114.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 05:17:21PM +0000, Hank Janssen wrote:
> 
> >And then Greg spoke:
> >> And then Greg spoke:
> > >>>On Tue, Aug 03, 2010 at 05:31:51PM +0000, Hank Janssen wrote:
> > >>> From: Hank Janssen <hjanssen@microsoft.com>
> > >>> 
> > >> >Fixed bounce offset kmap problem by using correct index
> > >>
> 
> SNIP
> 
> > > I actually goofed up in my previous code and used an incorrect index 
> > > number For this part of the code. It should have shown up in more 
> > > situations than what I have seen oddly enough.
> >
> >Please provide this type of information in the changelog section.
> >
> >If you want something backported to older stable kernels, add a:
> >	Cc: stable <stable@kernel.org>
> 
> I will re-submit all 5 patches and CC the stable mailing list on it as well.

5?  I see 6 of them here :)

thanks,

greg k-h
