Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934748Ab0GOUtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:49:09 -0400
Received: from mail.vyatta.com ([76.74.103.46]:39704 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934699Ab0GOUtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:49:06 -0400
Date: Thu, 15 Jul 2010 13:48:57 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Rick Jones <rick.jones2@hp.com>
Cc: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>,
        Bill Fink <billfink@mindspring.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        David Miller <davem@davemloft.net>, lists@wildgooses.com,
        davidsen@tmr.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Raise initial congestion window size / speedup slow start?
Message-ID: <20100715134857.38d519c5@nehalam>
In-Reply-To: <4C3F66BA.8010002@hp.com>
References: <4C3E0684.5060409@wildgooses.com>
	<4C3E1B54.40604@hp.com>
	<20100714203919.GD6682@nuttenaction>
	<20100714.145547.102555471.davem@davemloft.net>
	<20100714221301.GI6682@nuttenaction>
	<20100714234917.924f420d.billfink@mindspring.com>
	<AANLkTinbtGuMTPNyJqJtx_bqfQDPqbA1XqjhLe_pj1mX@mail.gmail.com>
	<4C3F66BA.8010002@hp.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 12:51:22 -0700
Rick Jones <rick.jones2@hp.com> wrote:

> I have to wonder if the only heuristic one could employ for divining the initial 
> congestion window is to be either pessimistic/conservative or 
> optimistic/liberal.  Or for that matter the only one one really needs here?
> 
> That's what it comes down to doesn't it?  At any one point in time, we don't 
> *really* know the state of the network and whether it can handle the load we 
> might wish to put upon it.  We are always reacting to it. Up until now, it has 
> been felt necessary to be pessimistic/conservative at time of connection 
> establishment and not rely as much on the robustness of the "control" part of 
> avoidance and control.
> 
> Now, the folks at Google have lots of data to suggest we don't need to be so 
> pessimistic/conservative and so we have to decide if we are willing to be more 
> optimistic/liberal.  Broadly handwaving, the "netdev we" seems to be willing to 
> be more optimistic/liberal in at least a few cases, and the question comes down 
> to whether or not the "IETF we" will be similarly willing.

I am not convinced that a host being aggressive with initial cwnd (Linux) would
not end up unfairly monopolizing available bandwidth compared to older more conservative
implementations (Windows). Whether fairness is important or not is another debate.

