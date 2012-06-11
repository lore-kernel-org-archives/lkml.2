Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2FKQCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:02:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56348 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab2FKQCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:02:06 -0400
Date: Mon, 11 Jun 2012 09:01:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] zsmalloc documentation
Message-ID: <20120611160140.GA23486@kroah.com>
References: <1339288874-2743-1-git-send-email-ngupta@vflare.org>
 <20120610004434.GA24894@localhost.localdomain>
 <4FD3EF26.7040108@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD3EF26.7040108@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2012 at 05:49:42PM -0700, Nitin Gupta wrote:
> On 06/09/2012 05:44 PM, Konrad Rzeszutek Wilk wrote:
> 
> > On Sat, Jun 09, 2012 at 05:41:14PM -0700, Nitin Gupta wrote:
> >> Documentation of various struct page fields
> >> used by zsmalloc.
> >>
> >> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> >>
> >> Changes for v2:
> >> 	- Regroup descriptions as suggested by Seth
> >                                                ^^ - Konrad
> > 
> > Otherwise: Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> 
> 
> Sorry about that, Konrad!
> Greg: Please let me know if I should resend the patch with corrected
> name in the changelog.

No need, I've fixed it up.

greg k-h
