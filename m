Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab0E0Ag7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 20:36:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24263 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab0E0Ag6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 20:36:58 -0400
Message-ID: <4BFDB60B.50106@oracle.com>
Date: Wed, 26 May 2010 17:00:11 -0700
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
References: <20100526115346.da5a02aa.sfr@canb.auug.org.au>	<4BFD42A6.6060206@oracle.com>	<20100527025020.da0c1bb7.sfr@canb.auug.org.au>	<20100526095606.beed820e.randy.dunlap@oracle.com> <20100527090923.c17a7ed4.sfr@canb.auug.org.au>
In-Reply-To: <20100527090923.c17a7ed4.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BFDBE88.0115:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/10 16:09, Stephen Rothwell wrote:
> Hi Randy,
> 
> On Wed, 26 May 2010 09:56:06 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>>> The kernel-doc tree is a quilt series :-(
>>
>> Yes.  and it's viewable without pulling/cloning.  ;)
> 
> Ah, I shouldn't reply to emails so late at night :-(
> 
>>> You can, of course, see the above commit in the linux-next tree via
>>> gitweb on kernel.org.
>>
>> Thanks.  Michal, I droppped these 3 patches.  Please keep them in the
>> kbuild tree.
> 
> If anything, the kernel-doc patches should be kept as they are much more
> extensive.  And the conflict was trivial.  The kbuild patch was just
> fixing a typo (tey -> they).

uh oh.  OK, thanks, I'll restore them.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
