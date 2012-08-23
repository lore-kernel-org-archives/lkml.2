Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab2HWSDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:03:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52112 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2HWSDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:03:38 -0400
Date: Thu, 23 Aug 2012 22:03:34 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 0/9] extended fdinfo via procfs series, v7
Message-ID: <20120823180334.GG1992@moon>
References: <20120823104323.040550004@openvz.org>
 <20120823122318.GD29943@fieldses.org>
 <20120823124427.GD1992@moon>
 <20120823135234.GE29943@fieldses.org>
 <20120823135606.GE1992@moon>
 <20120823152545.GC6923@fieldses.org>
 <20120823170239.GF1992@moon>
 <20120823175901.GA8591@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823175901.GA8591@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 01:59:01PM -0400, J. Bruce Fields wrote:
> > > You're using the common filehandle code instead of encoding your own
> > > from scratch, which was my only serious objection.
> > > 
> > 
> > Wait, Bruce, now I'm confused, if I understand all correctly
> > using common filehandle code from exportfs is preferred,
> 
> Right, that's what I meant, sorry if I was unclear.

I might be simply translating it wrong ;) Thanks Bruce!

	Cyrill
