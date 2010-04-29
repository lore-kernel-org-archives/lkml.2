Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab0D3SQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:16:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:42526 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735Ab0D3RaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:30:20 -0400
Subject: Re: [PATCH] firmware_class: fix memory leak - free allocated pages
From: David Woodhouse <dwmw2@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Ming Lei <tom.leiming@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <20100429145425.GA3703@suse.de>
References: <1272544821-22466-1-git-send-email-tomas.winkler@intel.com>
	 <20100429145425.GA3703@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Apr 2010 18:53:42 +0100
Message-ID: <1272563622.3367.4116.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 15:54 +0100, Greg KH wrote:
> On Thu, Apr 29, 2010 at 03:40:21PM +0300, Tomas Winkler wrote:
> > fix memory leak introduced by 6e03a201bbe patch:
> >  firmware: speed up request_firmware()
> 
> Who originally wrote this patch, Kay? 

It's kind of a joint effort. I think it's probably mine by a fairly
narrow majority.

>  If so, Tomas, please put a "From:" line at the top of the patch with
> the author's name so we get it right when commiting it.

And don't make up Signed-off-by lines. Although you can have that one of
mine now you've got it (since you've actually tested it).

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

