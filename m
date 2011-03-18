Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab1CRUAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:00:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52855 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab1CRUAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:00:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XctP8ZwijA8fLUHGMqoWi6rRw1O6jE9/BowVoYLwX4KJMV1mV38Lz+A5WF/PG3wdyz
         kA2Kr7VBal4RdVXX1nWHcGZAltziL8YZdlcZGisGwke8XVN6RO5zxgE86gh0//fG2Pao
         Wf3Aa8UU90h29MZXGNES5jTOQJVT2Mpvki1WQ=
Date: Fri, 18 Mar 2011 22:59:59 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peak@argo.troja.mff.cuni.cz, solar@openwall.com,
        kees.cook@canonical.com, dan.j.rosenberg@gmail.com, eugene@redhat.com,
        nelhage@ksplice.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] net: ipv4: add IPPROTO_ICMP socket kind
Message-ID: <20110318195959.GA6512@albatros>
References: <20110318180002.GA30912@albatros>
 <20110318.124711.116396341.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110318.124711.116396341.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 12:47 -0700, David Miller wrote:
> I kindly asked the other day for people to not submit new feature
> patches while we are amidst the merge window:

Sorry, I should have grepped the archives before sending the patch
(I'm not a subscriber of netdev@).  I'll wait for .39-rc1.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
