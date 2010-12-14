Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968Ab0LNU3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:29:42 -0500
Received: from smtp-in.kfki.hu ([148.6.0.25]:39144 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759759Ab0LNU3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:29:41 -0500
Date: Tue, 14 Dec 2010 21:29:39 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Luke-Jr <luke@dashjr.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: 6to4/Teredo IPv4 matching
In-Reply-To: <201012140940.11119.luke@dashjr.org>
Message-ID: <alpine.DEB.2.00.1012142127270.3226@blackhole.kfki.hu>
References: <201012140940.11119.luke@dashjr.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 14 Dec 2010, Luke-Jr wrote:

> Are there any plans to allow matching 6to4/Teredo IPv6 packets against IPv4 
> rules (or at least ipsets)? Recently I have a server that's been under 
> constant DDoS from China, and I found that when I use ipsets to drop 
> everything from China, some continue to hammer my server over 6to4 and/or 
> Teredo. So I just figured I'd throw the idea out there in case it hasn't 
> occurred to anyone yet. ;)

ipset 5 is about to be released in this week, with both IPv4 and IPv6 
support. But feeding the sets with the proper addresses/networks is left 
to the users :-).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
