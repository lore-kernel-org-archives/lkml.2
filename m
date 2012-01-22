Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2AVLVE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 06:21:04 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:24877
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804Ab2AVLVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 06:21:02 -0500
X-IronPort-AV: E=Sophos;i="4.71,551,1320620400"; 
   d="scan'208";a="128403592"
Date: Sun, 22 Jan 2012 12:20:59 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Thomas Meyer <thomas@m3y3r.de>
cc: mmarek@suse.cz, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: coccinelle: semantic patches related to devm_ functions - Fatal
 error/Parse error
In-Reply-To: <1327221144.1434.20.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.02.1201221219160.1981@hadrien>
References: <1327221144.1434.20.camel@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jan 2012, Thomas Meyer wrote:

> Hello,
>
> Again I wanted to run all coccinelle patches against the latest rc1, but
> I got this error:
> Fatal error: exception Failure("plus: parse error:
> = File "/home/thomas/source/linux/scripts/coccinelle/api/devm_request_and_ioremap.cocci", line 32, column 42,  charpos = 816
>    around = '\|', whole content = -                              \(res->name\|dev_name(dev)\))) {
> "
>
> I'm using version 1.0.0-0.rc4.2.fc16.

I think you need to get a newer version of coccinelle.  The bug is that it 
didn't like - on the ( or | or ) of a disjunction, but I fixed that.

julia
