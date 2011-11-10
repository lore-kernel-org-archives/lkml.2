Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab1KJO7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:59:08 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:38572 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1KJO7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:59:07 -0500
Date: Thu, 10 Nov 2011 09:59:02 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: =?iso-8859-1?B?Suly9G1l?= Pinot <ngc891@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Evolution of kernel size
Message-ID: <20111110145902.GA13619@elliptictech.com>
References: <20111110143333.GA29457@comet.deepsky.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111110143333.GA29457@comet.deepsky.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-10 23:33 +0900, Jérôme Pinot wrote:
> I took some time to make a graph of the evolution of the size of the
> linux kernel tar.bz2 since version 1.0 till 3.1 (297 releases).
> It doesn't count the stable branches (2.6.x.y).
> 
> Impressive, it's mostly exponential.
> If dev keeps same pace, we should break the 100MB at
> linux 3.19.
> 
> You can get the graph on my blog, I provide the data and the
> gnuplot batch file for graphing/fitting:
> http://ngc891.blogdns.net/?p=92 
> 
> It may interest some people :-)

What scale did you use for the horizontal axis?  I see numbers assigned
to each version in your gnuplot file, but no indication of how you came
up with them.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
