Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0LAKI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:08:28 -0500
Received: from lo.gmane.org ([80.91.229.12]:51162 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab0LAKI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:08:26 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: low overhead packet capturing on linux
Date: Wed, 1 Dec 2010 09:21:05 +0000
Message-ID: <1lghs7-l16.ln1@chipmunk.wormnet.eu>
References: <201011301728.05197.thomas@fjellstrom.ca>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.6-20100522 ("Lochruan") (UNIX) (Linux/2.6.32-5-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
>
> I'm working on a little tool to monitor and measure bandwidth use on a vm 
> host, down to keeping track of all guest and host bandwidth, including, 
> eventually per layer7 protocol use.
>
...iptables?  You get packet and byte counters there for free and you 
can have a 'web, smtp, $service[0], $service[1], ... , other' easily 
enough.

Five to eight years ago we (an ISP) used this at a previous workplace of 
mine to do xDSL traffic accounting for our users.

Cheers

-- 
Alexander Clouter
.sigmonster says: problem drinker, n.:
                  	A man who never buys.

