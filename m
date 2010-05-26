Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0EZPtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:49:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38635 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0EZPtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:49:01 -0400
Message-ID: <4BFD42A6.6060206@oracle.com>
Date: Wed, 26 May 2010 08:47:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, matt mooney <mfm@muteddisk.com>,
       Kirill Smelkov <kirr@mns.spb.ru>
Subject: Re: linux-next: manual merge of the kbuild tree with the kernel-doc
 tree
References: <20100526115346.da5a02aa.sfr@canb.auug.org.au>
In-Reply-To: <20100526115346.da5a02aa.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090205.4BFD42C0.00C4:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/10 18:53, Stephen Rothwell wrote:
> Hi Michal,
> 
> Today's linux-next merge of the kbuild tree got a conflict in
> Documentation/kbuild/makefiles.txt between commit
> 74bb7003010ff0998e280a6ade09381168ff20ec
> ("docs-kbuild-make-examples-content2") from the kernel-doc tree and
> commit e8d400a933fa44e2fba3849b084e1ae5814d7fca ("kbuild: fix a couple of
> typos in Documentation") from the kbuild tree.
> 
> The former also fixed the typo, so I used that.


If Michal has merged it, I'll drop it.

Michal, can I view your tree by using gitweb?  (i.e., http)
or is it only accessible by pulling/cloning?

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
