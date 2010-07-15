Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab0GOKYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 06:24:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52292 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932978Ab0GOKYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 06:24:22 -0400
Date: Thu, 15 Jul 2010 11:33:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: David Miller <davem@davemloft.net>, rick.jones2@hp.com,
        lists@wildgooses.com, davidsen@tmr.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Raise initial congestion window size / speedup slow start?
Message-ID: <20100715113334.46c440b8@lxorguk.ukuu.org.uk>
In-Reply-To: <20100714221301.GI6682@nuttenaction>
References: <4C3E0684.5060409@wildgooses.com>
	<4C3E1B54.40604@hp.com>
	<20100714203919.GD6682@nuttenaction>
	<20100714.145547.102555471.davem@davemloft.net>
	<20100714221301.GI6682@nuttenaction>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 00:13:01 +0200
Hagen Paul Pfeifer <hagen@jauu.net> wrote:

> * David Miller | 2010-07-14 14:55:47 [-0700]:
> 
> >Although section 3 of RFC 5681 is a great text, it does not say at all
> >that increasing the initial CWND would lead to fairness issues.
> 
> Because it is only one side of the medal, probing conservative the available
> link capacity in conjunction with n simultaneous probing TCP/SCTP/DCCP
> instances is another.
> 
> >To be honest, I think google's proposal holds a lot of weight.  If
> >over time link sizes and speeds are increasing (they are) then nudging
> >the initial CWND every so often is a legitimate proposal.  Were
> >someone to claim that utilization is lower than it could be because of
> >the currenttly specified initial CWND, I would have no problem
> >believing them.
> >
> >And I'm happy to make Linux use an increased value once it has
> >traction in the standardization community.
> 
> Currently I know no working link capacity probing approach, without active
> network feedback, to conservatively probing the available link capacity with a
> high CWND. I am curious about any future trends.

Given perfect information from the network nodes you still need to
traverse the network each direction and then return an answer which means
with a 0.5sec end to end time as in the original posting causality itself
demands 1.5 seconds to get an answer which is itself incomplete and
obsolete.

Causality isn't showing any signs of going away soon.

