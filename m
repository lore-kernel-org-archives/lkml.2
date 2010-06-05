Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab0FEUIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 16:08:17 -0400
Received: from lo.gmane.org ([80.91.229.12]:49286 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab0FEUIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 16:08:16 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: iptables slows tproxy SQUID with DNAT or REDIRECT
Date: Sat, 5 Jun 2010 20:44:56 +0100
Message-ID: <o2mqd7-hcr.ln1@chipmunk.wormnet.eu>
References: <AANLkTimTq_Bf-hJ7DmRT8bo7zwDKo2rfm8zhGvMckJz7@mail.gmail.com> <AANLkTileh4jCV5ILSUcEpcQ0ZZvKqXyOCKwpIhEhkEgG@mail.gmail.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tytus Rogalewski <tytanick@gmail.com> wrote:
>
> i am having very strange problem with my SQUID and iptables.
> It is for sure NOT A SQUID ISSUE (i've tested 6 different versions of
> squid, 2.7.x , 3.0.x and 3.1.x - and  other people dont have this
> issue)
>
...I assume you tried removing all your iptables rules (including 
unloading all the iptables related modules) and configuring a client 
workstation to use squid manually and the problem disappeared?

Cheers

-- 
Alexander Clouter
.sigmonster says: Look before you leap.
                  		-- Samuel Butler

