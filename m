Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab0E0WHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:07:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62078 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab0E0WG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:06:58 -0400
Message-ID: <4BFEECD3.7020203@oracle.com>
Date: Thu, 27 May 2010 15:06:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Ralph Campbell <ralph.campbell@qlogic.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
Subject: Re: linux-next: Tree for May 27 (infiniband: qib)
References: <20100527152628.b23a14c6.sfr@canb.auug.org.au>	<20100527090503.d229dc53.randy.dunlap@oracle.com> <adaaarlvx0z.fsf@roland-alpha.cisco.com>
In-Reply-To: <adaaarlvx0z.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BFEECFD.00EF:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/10 14:45, Roland Dreier wrote:
>  > However, it looks like qib needs to handle DCA config in a way that
>  > is similar to how it is handled in drivers/net/{myri10ge,igb,ixgbe}/
>  > instead of assuming that DCA is enabled.
> 
> Looks like we're just going to rip out DCA support for now.
> 
>  > And please fix the linux-next 2010-may-25 reported qib problem:
>  >   http://lkml.org/lkml/2010/5/25/321
> 
> I think that should be fixed in my for-next branch already (at least I
> have a patch from Ralph called "IB/qib: Fix undefined symbol error when
> CONFIG_PCI_MSI=n" in there).

Sounds good.  Was is posted to linux-rdma?

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
