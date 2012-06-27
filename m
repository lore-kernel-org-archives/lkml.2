Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab2F0PsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:48:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20677 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2F0PsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:48:01 -0400
Date: Wed, 27 Jun 2012 11:40:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 1/3] zram/zcache: swtich Kconfig dependency from X86 to
 ZSMALLOC
Message-ID: <20120627154003.GI17154@phenom.dumpdata.com>
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1340640878-27536-2-git-send-email-sjenning@linux.vnet.ibm.com>
 <4FEA71E5.5090808@kernel.org>
 <20120627024301.GA8468@kroah.com>
 <4FEA74D6.8030107@kernel.org>
 <20120627032101.GA16419@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627032101.GA16419@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 08:21:01PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Jun 27, 2012 at 11:49:58AM +0900, Minchan Kim wrote:
> > Hi Greg,
> > 
> > On 06/27/2012 11:43 AM, Greg Kroah-Hartman wrote:
> > 
> > > On Wed, Jun 27, 2012 at 11:37:25AM +0900, Minchan Kim wrote:
> > >> On 06/26/2012 01:14 AM, Seth Jennings wrote:
> > >>
> > >>> This patch switches zcache and zram dependency to ZSMALLOC
> > >>> rather than X86.  There is no net change since ZSMALLOC
> > >>> depends on X86, however, this prevent further changes to
> > >>> these files as zsmalloc dependencies change.
> > >>>
> > >>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> > >>
> > >> Reviewed-by: Minchan Kim <minchan@kernel.org>
> > >>
> > >> It could be merged regardless of other patches in this series.
> > > 
> > > I already did :)
> > 
> > 
> > It would have been better if you send merge mail to Ccing people.
> > Anyway, Thanks!
> 
> I do, for people on the cc: in the signed-off-by area of the patch.  For
> me to manually add the people on the cc: of the email, I would have to
> modify git to add them to the commit somehow, sorry.

Is that some other script you have that does that?
