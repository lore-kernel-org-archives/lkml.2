Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab0HDTiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:38:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:37727 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab0HDTh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:37:59 -0400
Date: Wed, 4 Aug 2010 12:28:39 -0700
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/6] staging: hv: Fixed bounce kmap problem by using
 correct index
Message-ID: <20100804192839.GA29851@suse.de>
References: <8AFC7968D54FB448A30D8F38F259C56223FD0D21@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100803173732.GA1455@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56223FE8B19@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100804170406.GA28217@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56223FE8EF5@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100804182318.GB29046@suse.de>
 <81D58C97-B9A7-4217-9912-7EE6A3FE7DD0@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81D58C97-B9A7-4217-9912-7EE6A3FE7DD0@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 06:50:24PM +0000, Hank Janssen wrote:
> On Aug 4, 2010, at 11:26, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Aug 04, 2010 at 05:17:21PM +0000, Hank Janssen wrote:
> >>> 
> >> 
> >> I will re-submit all 5 patches and CC the stable mailing list on it as well.
> > 
> > 5?  I see 6 of them here :)
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> True but anise you rejected the todo patch there will only be 5.
> Unless you are willing to take the todo patch. :)

Doh, you are right, nevermind :)

thanks,

greg k-h
