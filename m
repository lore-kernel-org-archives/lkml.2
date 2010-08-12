Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065Ab0HLRhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:37:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38467 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0HLRht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:37:49 -0400
Message-ID: <4C643136.5090808@oracle.com>
Date: Thu, 12 Aug 2010 10:36:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: linux-nfs@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 9 (nfs)
References: <20100809132314.789e13f3.sfr@canb.auug.org.au>	 <20100809100856.b03a9bc1.randy.dunlap@oracle.com>	 <20100812091842.6a3b84b9.randy.dunlap@oracle.com> <1281634268.14329.18.camel@heimdal.trondhjem.org>
In-Reply-To: <1281634268.14329.18.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/10 10:31, Trond Myklebust wrote:
> On Thu, 2010-08-12 at 09:18 -0700, Randy Dunlap wrote:
>> On Mon, 9 Aug 2010 10:08:56 -0700 Randy Dunlap wrote:
>>
>> ping??
> 
> Hi Randy,
> 
> I'm sorry. A heavy travel schedule is affecting my response time at the
> moment. I'll try to take care of this by Tuesday (when I get back home)
> if not before.

No problem.  Just wanted to make sure that it's not lost.

Thanks.


> Cheers
>   Trond
> 
>>> On Mon, 9 Aug 2010 13:23:14 +1000 Stephen Rothwell wrote:
>>>
>>>> Hi all,
>>>>
>>>> As the merge window is open, please do not add 2.6.37 material to your
>>>> linux-next included trees until after 2.6.36-rc1.
>>>>
>>>> Changes since 20100807:
>>>
>>>
>>> ERROR: "svc_gss_principal" [fs/nfs/nfs.ko] undefined!
>>>
>>>
>>> because in fs/nfs/Kconfig, NFS_V4 selects RPCSEC_GSS_KRB5
>>> and/or in fs/nfsd/Kconfig, NFSD_V4 selects RPCSEC_GSS_KRB5.
>>>
>>> RPCSEC_GSS_KRB5 does 5 selects, but none of these is enforced/followed
>>> by the fs/nfs[d]/Kconfig configs:
>>>
>>> 	select SUNRPC_GSS
>>> 	select CRYPTO
>>> 	select CRYPTO_MD5
>>> 	select CRYPTO_DES
>>> 	select CRYPTO_CBC
>>>
>>>
>>> Failing config is attached.
>>> ---
>>
>>
>> ---
>> ~Randy
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
