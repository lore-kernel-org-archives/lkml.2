Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab0CXQK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:10:57 -0400
Received: from daytona.panasas.com ([67.152.220.89]:10441 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753183Ab0CXQKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:10:55 -0400
Message-ID: <4BAA398C.5050901@panasas.com>
Date: Wed, 24 Mar 2010 18:10:52 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Benny Halevy <bhalevy@panasas.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT case
 to use of do_last()
References: <4BAA3493.1030802@panasas.com> <20100324160037.GP30031@ZenIV.linux.org.uk> <4BAA3828.2070506@panasas.com> <20100324160754.GQ30031@ZenIV.linux.org.uk>
In-Reply-To: <20100324160754.GQ30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2010 16:10:55.0173 (UTC) FILETIME=[95177750:01CACB6C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 06:07 PM, Al Viro wrote:
> On Wed, Mar 24, 2010 at 06:04:56PM +0200, Boaz Harrosh wrote:
>>> Bloody impressive...  Does that happen to underlying fs or to what you
>>> are seeing via NFS?
>>
>> Only via NFS. All local access is fine.
>>
>> After the corruption above I can cd to the local mount cp a fresh copy
>> of .git/index file and play around just fine.
>> Once I return to the NFS mounted directory, a git status will do it.
>> It does not matter if caches are cold (Takes a long time) or hot it happens
>> every time.
>>
>> Weird I know, I'm playing some more with it as we speak
> 
> What happens if you export to box running older kernel *or* from box
> running older kernel?  IOW, is that nfsd or nfs client getting unhappy?
> I'd suspect the latter, but...


Good question, I'm just getting to that because currently it's all
over localhost (same kernel, BTW inside a UML)

I will try what you said. Please through any other tests on me, if needed.

Boaz

