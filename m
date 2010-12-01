Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0LAKSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:18:43 -0500
Received: from tomasu.net ([64.85.170.234]:34978 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab0LAKSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:18:42 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: low overhead packet capturing on linux
Date: Wed, 1 Dec 2010 03:18:25 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
Cc: linux-kernel@vger.kernel.org
References: <201011301728.05197.thomas@fjellstrom.ca> <1lghs7-l16.ln1@chipmunk.wormnet.eu>
In-Reply-To: <1lghs7-l16.ln1@chipmunk.wormnet.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012010318.25133.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On December 1, 2010, you wrote:
> Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> > I'm working on a little tool to monitor and measure bandwidth use on a vm
> > host, down to keeping track of all guest and host bandwidth, including,
> > eventually per layer7 protocol use.
> 
> ...iptables?  You get packet and byte counters there for free and you
> can have a 'web, smtp, $service[0], $service[1], ... , other' easily
> enough.

Not with full layer7 support these days. None of the old things like pp2p or 
l7filter will even apply to anything remotely resembling a recent kernel.

Also I'm not sure it'll dynamically keep track of hosts. My solution will 
track all hosts it sees. Where as iptables would be somewhat manual.

> Five to eight years ago we (an ISP) used this at a previous workplace of
> mine to do xDSL traffic accounting for our users.
> 
> Cheers


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
