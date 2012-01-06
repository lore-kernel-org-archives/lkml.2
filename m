Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab2AFTxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 14:53:48 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:59223 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756423Ab2AFTxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 14:53:46 -0500
X-Sasl-enc: Av7NBrVIVxTZn2ISyq47+WGqNF+md+AkinbrwyFMdz18 1325879625
Date: Fri, 6 Jan 2012 11:53:32 -0800
From: Greg KH <greg@kroah.com>
To: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
Cc: Breno Leitao <brenohl@br.ibm.com>, Zac Storer <zac.3.14159@gmail.com>,
        leitao@linux.vnet.ibm.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 29/29] Drivers: tty: serial: jsm: jsm_tty: fixed a brace
 coding style issue
Message-ID: <20120106195332.GA10814@kroah.com>
References: <1321596182-11031-1-git-send-email-zac.3.14159@gmail.com>
 <4EC66C07.9020009@br.ibm.com>
 <4F073CF3.70604@linux.vnet.ibm.com>
 <4F074F89.6060300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F074F89.6060300@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 05:46:17PM -0200, Lucas Kannebley Tavares wrote:
> On 01/06/2012 04:26 PM, Lucas Kannebley Tavares wrote:
> >On 11/18/2011 12:30 PM, Breno Leitao wrote:
> >>On 11/18/2011 03:03 AM, Zac Storer wrote:
> >>>Fixed a brace coding style issue.
> >>>
> >>>Signed-off-by: Zac Storer<zac.3.14159@gmail.com>
> >>Acked-by: Breno Leitao<brenohl@br.ibm.com>
> >Acked-by: Lucas Kannebley Tavares<lucaskt@linux.vnet.ibm.com>
> >
> 
> Adding Alan and Greg so they can catch this up on their trees.

Catch what up with what?

What patch is this?  Where is it?  Why wasn't it sent to me in the first
place?

Also note, the merge window for new patches to be sent to subsystem
maintainers has been over for a week or so now, all of of the
maintainers are now busy merging stuff with Linus, so trivial stuff like
this is going to have to wait a few weeks at the earliest before it can
start to be queued up.

thanks,

greg k-h
