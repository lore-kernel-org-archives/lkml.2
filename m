Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab1EJTpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:45:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54330 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1EJTpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lhIiUyDPH3sVVMye0w5xA+2RoFrv8rRGtizjHImJK3ARR4S4e2oxy9nX2ssry4GpBN
         hDIveU+jCsbZ02tnnXMmoDBcQn1HFkQxtdEn/uYTECcQUXGuDofWbKubcHLY4XYfsjef
         QPiqbTlNMLvG5DziTet+EfOuSkD8LI6j1hfSc=
Date: Tue, 10 May 2011 23:45:48 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: David Miller <davem@davemloft.net>
Cc: solar@openwall.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peak@argo.troja.mff.cuni.cz, kees.cook@canonical.com,
        dan.j.rosenberg@gmail.com, eugene@redhat.com, nelhage@ksplice.com,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH v2] net: ipv4: add IPPROTO_ICMP socket kind
Message-ID: <20110510194547.GA8884@albatros>
References: <20110412.142534.183049889.davem@davemloft.net>
 <20110510180957.GA3262@albatros>
 <20110510.121550.112583080.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510.121550.112583080.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 12:15 -0700, David Miller wrote:
> A lot has changed in this area, your code won't even compile, so
> please adjust your patch to fit net-next-2.6 as needed, perhaps
> using net/ipv4/raw.c and net/ipv4/udp.c as a guide.

Sure, will do it.

Thanks!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
