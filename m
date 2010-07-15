Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab0GOHsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 03:48:38 -0400
Received: from mail1.nippynetworks.com ([212.227.250.41]:32858 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578Ab0GOHsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 03:48:35 -0400
Message-ID: <4C3EBD51.80406@wildgooses.com>
Date: Thu, 15 Jul 2010 08:48:33 +0100
From: Ed W <lists@wildgooses.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.10) Gecko/20100512 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: Tom Herbert <therbert@google.com>
CC: Hagen Paul Pfeifer <hagen@jauu.net>, Rick Jones <rick.jones2@hp.com>,
        David Miller <davem@davemloft.net>, davidsen@tmr.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jerry Chu <hkchu@google.com>, Nandita Dukkipati <nanditad@google.com>
Subject: Re: Raise initial congestion window size / speedup slow start?
References: <4C3D94E3.9080103@wildgooses.com>	<4C3DD5EB.9070908@tmr.com>	<20100714.111553.104052157.davem@davemloft.net>	<4C3E0684.5060409@wildgooses.com>	<4C3E1B54.40604@hp.com>	<20100714203919.GD6682@nuttenaction> <AANLkTikTyZGQWWIBzYSQWpUK30xxbMXLbJXeHahWnlIi@mail.gmail.com>
In-Reply-To: <AANLkTikTyZGQWWIBzYSQWpUK30xxbMXLbJXeHahWnlIi@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/2010 05:12, Tom Herbert wrote:
> There is an Internet draft
> (http://datatracker.ietf.org/doc/draft-hkchu-tcpm-initcwnd/) on
> raising the default Initial Congestion window to 10 segments, as well
> as a SIGCOMM paper (http://ccr.sigcomm.org/online/?q=node/621).
>    

You guys have obviously done a lot of work on this, however, it seems 
that there is a case for introducing some heuristics into the choice of 
init cwnd as well as offering the option to go larger?  An initial size 
of 10 packets is just another magic number that obviously works with the 
median bandwidth delay product on today's networks - can we not do 
better still?

Seems like a bunch of clever folks have already suggested tweaks to the 
steady stage congestion avoidance, but so far everyone is afraid to 
touch the early stage heuristics?

Also would you guys not benefit from wider deployment of ECN?  Can you 
not help find some ways that deployment could be increased?  At present 
there are big warnings all over the option that it causes some problems, 
but there is no quantification of how much and really whether this 
warning is still appropriate?

Ed W

