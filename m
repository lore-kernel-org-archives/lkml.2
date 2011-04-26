Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1DZT4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:56:47 -0400
Received: from 1wt.eu ([62.212.114.60]:35057 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905Ab1DZT4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:56:45 -0400
Date: Tue, 26 Apr 2011 21:56:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: stable@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
        Tejun Heo <tj@kernel.org>, stable-review@kernel.org
Subject: Re: [stable] [PATCH 029/173] pata_mpc52xx: inherit from ata_bmdma_port_ops
Message-ID: <20110426195632.GC19594@1wt.eu>
References: <20110425200234.252228845@pcw.home.local> <4DB6A216.1010609@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB6A216.1010609@mvista.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergei,

On Tue, Apr 26, 2011 at 02:44:38PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 26-04-2011 0:03, Willy Tarreau wrote:
> 
> >2.6.27.59-stable review patch.  If anyone has any objections, please let 
> >us know.
> 
>    DMA support was added to this driver only in 2.6.29, hence this patch is 
> not needed in 2.6.27.y...

Perfect, patch dropped.

Thanks Sergei,
Willy

