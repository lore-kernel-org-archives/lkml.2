Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140Ab2FGPMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:12:08 -0400
Received: from mx2.netapp.com ([216.240.18.37]:61578 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab2FGPMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:12:05 -0400
X-IronPort-AV: E=Sophos;i="4.75,731,1330934400"; 
   d="scan'208";a="653921873"
Message-ID: <4FD0C4C2.8020605@netapp.com>
Date: Thu, 07 Jun 2012 11:12:02 -0400
From: Bryan Schumaker <bjschuma@netapp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: NFS regression in v3.5-rc1: mount.nfs yells about incorrect mount
 option
References: <20120607150456.GO12795@8bytes.org>
In-Reply-To: <20120607150456.GO12795@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 11:04 AM, Joerg Roedel wrote:
> Hi,
> 
> since Linux v3.5-rc1 I experience problems using NFS between my
> machines. One of my test-machines gives me:
> 
> root@chrom:~# mount lemmy:/data/repos /data/lemmy
> mount.nfs: an incorrect mount option was specified

Hi,

Can you use `mount -v` to get more output?

- Bryan
> 
> The same works fine on v3.4. I tried to bisect but got different errors
> in between. In the end, using every non-working case as bad, bisection
> pointed to:
> 
> 	db83335 NFS: Let mount data parsing set the NFS version
> 
> but that at that commit the kernel panics when trying to mount the NFS
> tree. Please let me know if you need any additional information.
> 
> Regards,
> 
> 	Joerg
> 
> 


