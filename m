Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab2JRHAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 03:00:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2JRHAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 03:00:35 -0400
Date: Thu, 18 Oct 2012 09:00:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefani Seibold <stefani@seibold.net>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove untouched code in kfifo_in
In-Reply-To: <1350538446.10942.1.camel@wall-e>
Message-ID: <alpine.LNX.2.00.1210180858420.26584@pobox.suse.cz>
References: <1350463837-30244-1-git-send-email-weiyang@linux.vnet.ibm.com>  <alpine.LNX.2.00.1210171434360.17129@pobox.suse.cz>  <20121017140136.GA7913@richard.(null)>  <alpine.LNX.2.00.1210171605030.17129@pobox.suse.cz>  <1350503509.9947.1.camel@wall-e>
 <20121018015959.GD4511@richard.(null)> <1350538446.10942.1.camel@wall-e>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Stefani Seibold wrote:

> > >This was introduce by me to suppress a compiler warning, so don't remove
> > >it. 
> > Which warning? I compile by removing this, but not find warning.
> > I compile it on x86_64 platform.
> > >
> 
> Sorry, i can't remember, it is three years and two gcc major releases
> ago.

Well, exactly. gcc that needs this workaround seems to be pretty broken, 
and I am not seeing any warnings either myself.

As it's quite a obscure and confusing construction, I'd not hesitate 
removing that.

-- 
Jiri Kosina
SUSE Labs
