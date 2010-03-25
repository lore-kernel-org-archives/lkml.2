Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0CYKLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:11:42 -0400
Received: from daytona.panasas.com ([67.152.220.89]:28967 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750927Ab0CYKLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:11:40 -0400
Message-ID: <4BAB36D8.6010402@panasas.com>
Date: Thu, 25 Mar 2010 12:11:36 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <4BAA3493.1030802@panasas.com>	<20100324160037.GP30031@ZenIV.linux.org.uk>	<4BAA3828.2070506@panasas.com>	<20100324160754.GQ30031@ZenIV.linux.org.uk>	<4BAA398C.5050901@panasas.com>	<20100324163948.GR30031@ZenIV.linux.org.uk>	<4BAA48A3.1030801@panasas.com>	<4BAA4CAC.6060104@panasas.com>  <4BAA5035.1060906@panasas.com>	<1269453756.5982.33.camel@localhost.localdomain> <1269454208.5982.34.camel@localhost.localdomain>
In-Reply-To: <1269454208.5982.34.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 10:11:39.0464 (UTC) FILETIME=[8F4D0C80:01CACC03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 24, 2010, 20:10 +0200, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> On Wed, 2010-03-24 at 14:02 -0400, Trond Myklebust wrote: 
>> I'd say you have a corruption issue either on the server side or on your
>> client.
> 
> By the way. Does this issue happen with NFSv4 too, or is it only
> NFSv4.1?

I reproduced this both over v4 and v4.1 with ext3 exported on the server.

Benny

> 
> Trond
> 
> _______________________________________________
> pNFS mailing list
> pNFS@linux-nfs.org
> http://linux-nfs.org/cgi-bin/mailman/listinfo/pnfs
