Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154Ab0FKK14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:27:56 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41133 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759745Ab0FKK1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:27:55 -0400
Date: Fri, 11 Jun 2010 15:56:54 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Panic on boot on today's tip/master
Message-ID: <20100611102654.GB9562@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100610112839.GK5878@linux.vnet.ibm.com>
 <4C11CA1C.3010102@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4C11CA1C.3010102@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/10/2010 04:28 AM, Srikar Dronamraju wrote:
> > When I updated my tip/master and rebooted into it, I am seeing a panic on boot.
> > 
> > 
> > Here is the ooops message. (x86_64 box)
> > 
> > 
> > previously it booted well with commit
> > a2e42da15c9c72bc7caf9e494d409819babbc9c8
> > 
> 
> Any way you could run a bisect between these commits?
> 
> 	-hpa


Now sure I got to those commit id's. Those don't seem to be present in
the git log when I grep today. And I am able to boot the system with today's
tip tree.

I am extremely sorry for the noise. 

--
Thanks and Regards
Srikar
