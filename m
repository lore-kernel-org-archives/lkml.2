Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030375Ab2CGT7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:59:37 -0500
Received: from bay0-omc3-s25.bay0.hotmail.com ([65.54.190.163]:56062 "EHLO
	bay0-omc3-s25.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932729Ab2CGT7g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:59:36 -0500
Message-ID: <BAY167-W127BF20C0952D601BC4381FBD560@phx.gbl>
X-Originating-IP: [66.87.0.153]
From: Xiachen Dong <xiachendong@hotmail.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: RE: 2.6.36 and higher version kernel slower than 2.6.25.1 kernel?
Date: Wed, 7 Mar 2012 14:59:35 -0500
Importance: Normal
In-Reply-To: <20120307194728.GA26341@kroah.com>
References: <BAY167-W124DBC204D9E95FC00BAA44BD560@phx.gbl>,<20120307194728.GA26341@kroah.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 07 Mar 2012 19:59:35.0780 (UTC) FILETIME=[D2277240:01CCFC9C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for your reply.

There could be quite some code change from 2.6.25.1 to 2.6.36. What we are doing now is to find the first version starting from 2.6.25.1 that has the performance hit. Then we start comparing the code and see what's changed. Looks like 2.6.28.7 is OK.

Haven't tried 3.2.29 yet because 3.2.29 probably won't be available in the BSP from our board manufacturer in the near future. I'll try 3.2.29 tonight on X86 CPU  anyway and get you updated.

Thanks,

Xiachen

----------------------------------------
> Date: Wed, 7 Mar 2012 11:47:28 -0800
> From: gregkh@linuxfoundation.org
> To: xiachendong@hotmail.com
> CC: linux-kernel@vger.kernel.org
> Subject: Re: 2.6.36 and higher version kernel slower than 2.6.25.1 kernel?
>
> On Wed, Mar 07, 2012 at 12:04:33PM -0500, Xiachen Dong wrote:
> >
> > Hi,
> >
> > Recently we upgrade the OS for our AT91RM9200 platform from 2.6.25.1
> > to 2.6.36. We run the SQLITE3 database insertion tests for the new
> > kernel. The test result shows that 2.6.36 kernel is around 10% slower
> > than the 2.6.25.1.
>
> Ick.
>
> As you noted this is still present in 3.0.23, any chance to try out
> 3.2.9?
>
> And as you seem to have a good reproducable test, can you run 'git
> bisect' between 2.6.35 and 2.6.36 to find the patch that causes this
> problem so we can work on resolving it?
>
> thanks,
>
> greg k-h
 		 	   		  