Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0KZQ3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:29:39 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:53944 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab0KZQ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:29:37 -0500
Date: Fri, 26 Nov 2010 11:29:29 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Michal Marek <mmarek@suse.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: Re: Unused config options in drivers/mtd (Re: running my kernel
 scanning scripts on your favourite part of the tree)
In-Reply-To: <4CEE8B70.4070500@suse.cz>
Message-ID: <alpine.DEB.2.00.1011261122140.13435@localhost6.localdomain6>
References: <alpine.DEB.2.00.1011090711410.5783@localhost6.localdomain6> <4CEE8B70.4070500@suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010, Michal Marek wrote:

> CC the mtd maintainer and mailinglist and adjusted subject. Robert, you
> should report such bugs to the maintainer / author of the code in
> question, otherwise your mail might end up unnoticed on LKML.
>
> Michal

 {sigh}.  the point of my earlier post was not specifically to point
out unused kernel config vars in the MTD code; rather, it was to
suggest that anyone who's interested can run my scanning scripts to
locate such things for themselves in their favourite subsystem(s) -- i
simply used the MTD code as a working example.

  and, BTW, there are still dead config variables in the code that go
back *several* major versions, even though i've documented them just
as many times here:

  http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup

so if you're curious, the scripts are here:

  http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup_scripts

rday

--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
