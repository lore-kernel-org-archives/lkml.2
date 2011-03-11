Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1CKDeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 22:34:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41906 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1CKDeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 22:34:09 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JajUpojGUCNJNEghbWQA:9 a=RM6LLnsM8Lbp_-HS0mWBTzSPPpsA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 10 Mar 2011 22:34:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20110311033406.GA11004@home.goodmis.org>
References: <AANLkTimnHtVS=SFopgyjAAQDW8bXDKDXf+YvEtPdpPsA@mail.gmail.com>
 <20110310.155556.48513201.davem@davemloft.net>
 <AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
 <20110310.163434.260095615.davem@davemloft.net>
 <AANLkTimAPqTYT_j6t3cT32WfD6cQPySG0tnQVhC8Z=NO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimAPqTYT_j6t3cT32WfD6cQPySG0tnQVhC8Z=NO@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 04:51:34PM -0800, Linus Torvalds wrote:
> 
> The reasons can be any of:
> 
>  - "I don't want to get too far away from upstream". This is very
> understandable, but I have asked people to please _not_ merge "random
> trees of the day". Please use major releases for this (or, if worst
> comes to worst, -rc releases) rather than just do something else.
> 

What are you throughts on starting work from a tree. Most of my work is
usually based off of some branch in tip, but sometimes when I'm pulling
in patches that are not really related to anything, I just simply grab
whatever the latest Linus branch is and start from there.

Is it preferable to instead start from one of the official releases?

-- Steve

