Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab1FGUvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:51:07 -0400
Received: from mail.lang.hm ([64.81.33.126]:52665 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495Ab1FGUvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:51:06 -0400
Date: Tue, 7 Jun 2011 13:50:37 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matt Mackall <mpm@selenic.com>
cc: Stratos Psomadakis <psomas@ece.ntua.gr>, linux-kernel@vger.kernel.org,
        Frank Kingswood <frank@kingswood-consulting.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ketchup script and 3.0
In-Reply-To: <1307479572.4204.977.camel@calx>
Message-ID: <alpine.DEB.2.02.1106071349000.28905@asgard.lang.hm>
References: <4DEDD5F4.1070602@kingswood-consulting.co.uk>  <1307451186.4204.953.camel@calx>  <4DEE808D.6020405@ece.ntua.gr>  <1307477435.4204.968.camel@calx>  <4DEE8AD9.3050508@ece.ntua.gr> <1307479572.4204.977.camel@calx>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, Matt Mackall wrote:

> But my point is that if we have adhoc transitions, we will encounter the
> "fix all the scripts and websites" pain at every transition. And tools
> that are managed via distros and the like can literally take years to
> get into the hands of users. It'd be nice if the copy of ketchup shipped
> in <enterprise distro> just worked 3 years from now because 4.0 wasn't a
> surprise.

if you special case 2.4->2.6, and make the default that 4.0 > 3.x, 5.0 > 
4.x, etc won't things 'just work' for the forseeable future?

David Lang
