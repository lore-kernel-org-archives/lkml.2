Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2ISLoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:44:54 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:42630 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab2ISLox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:44:53 -0400
X-Greylist: delayed 1600 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 07:44:52 EDT
Message-ID: <5059A9F0.2070409@cape-horn-eng.com>
Date: Wed, 19 Sep 2012 13:18:08 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Fwd: Re: [PATCH] NFS: Fix Oopses in nfs_lookup_revalidate and nfs4_lookup_revalidate
References: <503361AF.8030707@cape-horn-eng.com>
In-Reply-To: <503361AF.8030707@cape-horn-eng.com>
X-Enigmail-Version: 1.4.4
X-Forwarded-Message-Id: <503361AF.8030707@cape-horn-eng.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Df-Sender: cmljaGFyZC5lbXNAY2FwZS1ob3JuLWVuZy5jb20=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I still don't see this patch in the 3.5.x series.
Will it make it into 3.5.5?

Thanks,
Richard


-------- Original Message --------
Subject: Re: [PATCH] NFS: Fix Oopses in nfs_lookup_revalidate and
nfs4_lookup_revalidate
Date: Tue, 21 Aug 2012 12:23:43 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: linux-nfs@vger.kernel.org

On 08/15/2012 10:49 PM, Trond Myklebust wrote:
> This Oops affects 3.5 kernels and older, and is due to lookup_one_len()
> calling down to the dentry revalidation code with a NULL pointer
> to struct nameidata.
> 
> It is fixed upstream by commit 0b728e1911c (stop passing nameidata *
> to ->d_revalidate())
> 
> Reported-by: Richard Ems <richard.ems@cape-horn-eng.com>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>


Hi Trond,

I don't see this patch going into 3.5.3 at
http://www.kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.5.3-rc1.gz
.
Shouldn't it be included in 3.5.3 ?

Thanks,
Richard


-- 
Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. Dómine 1, 5º piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com


