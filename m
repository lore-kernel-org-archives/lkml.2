Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab0CYJNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:13:32 -0400
Received: from daytona.panasas.com ([67.152.220.89]:43310 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750834Ab0CYJNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:13:30 -0400
Message-ID: <4BAB2937.6050703@panasas.com>
Date: Thu, 25 Mar 2010 11:13:27 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <4BAA3493.1030802@panasas.com>	 <20100324160037.GP30031@ZenIV.linux.org.uk>	<4BAA3828.2070506@panasas.com>	 <20100324160754.GQ30031@ZenIV.linux.org.uk>	<4BAA398C.5050901@panasas.com>	 <20100324163948.GR30031@ZenIV.linux.org.uk>	<4BAA48A3.1030801@panasas.com>	 <4BAA4CAC.6060104@panasas.com>  <4BAA5035.1060906@panasas.com>	 <1269453756.5982.33.camel@localhost.localdomain> <1269454208.5982.34.camel@localhost.localdomain>
In-Reply-To: <1269454208.5982.34.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 09:13:29.0364 (UTC) FILETIME=[6F0A0D40:01CACBFB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 08:10 PM, Trond Myklebust wrote:
> On Wed, 2010-03-24 at 14:02 -0400, Trond Myklebust wrote: 
>> I'd say you have a corruption issue either on the server side or on your
>> client.
> 

It is surely a corruption on the client. I've tested with an old server
and it fails just the same.

> By the way. Does this issue happen with NFSv4 too, or is it only
> NFSv4.1?
> 
> Trond
> 

-o minorversion=0 or =1 does not matter.
nfsv3 does not have that problem. (Same client different server though)

Boaz
