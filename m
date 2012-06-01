Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964901Ab2FAPbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:31:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab2FAPbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:31:35 -0400
Subject: Re: seq_file: Use larger buffer to reduce time traversing lists
From: Steven Whitehouse <swhiteho@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, nstraz@redhat.com
In-Reply-To: <1338563900.2760.1529.camel@edumazet-glaptop>
References: <1338547193.2708.16.camel@menhir>
	 <1338552626.2760.1510.camel@edumazet-glaptop>
	 <1338553486.2708.25.camel@menhir>
	 <1338554890.2760.1517.camel@edumazet-glaptop>
	 <1338556468.2708.41.camel@menhir>
	 <1338557229.2760.1520.camel@edumazet-glaptop>
	 <1338560283.2708.59.camel@menhir>
	 <1338562627.2760.1526.camel@edumazet-glaptop>
	 <1338562897.2760.1528.camel@edumazet-glaptop>
	 <1338563900.2760.1529.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 01 Jun 2012 16:30:36 +0100
Message-ID: <1338564636.2708.75.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2012-06-01 at 17:18 +0200, Eric Dumazet wrote:
> On Fri, 2012-06-01 at 17:01 +0200, Eric Dumazet wrote:
> 
> > All unix sockets are linked into a single list, no hash table, so its
> > not very easy right now.
> > 
> 
> Oops, there is a hash table, so patch is coming ;)
> 
> 

The only reason that I looked at the unix sockets was that Nate Straz,
who originally reported the issue to me had sent me a test program for
unix sockets which he wrote in response to one of your earlier emails.
So I converted it to tcp just to do that quick test,

Steve.


