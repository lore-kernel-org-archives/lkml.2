Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab0JYN51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:57:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59017 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab0JYN50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fcd1xLaC5JqrpBKq/QXpGuKwfjahAK2UiCesi5NMXho7lnaLs8t1ZitR0ZHQ4vJraS
         oJVvzYHfKx+AtM8Fk+ykZzNnw7H0hYDIKffLjMAmNAcMEBSbqEbidnCMtvu+u8ZtL57Z
         RqXusNluvJkWqTiIh7h5EO4S+Ro1IOnKRoxu8=
Date: Mon, 25 Oct 2010 21:57:10 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: divya <dipraksh@linux.vnet.ibm.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: BUG with the kernel version 2.6.36-rc1 on power machine
Message-ID: <20101025135710.GA5461@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <4CC13B2C.7090908@linux.vnet.ibm.com>
 <4CC13FFF.7040200@linux.vnet.ibm.com>
 <AANLkTikmpohofzO_dV_Dv8EfcEMsyy4cdhGMUD-PAFO3@mail.gmail.com>
 <1287774802.19497.1.camel@subratamodak.linux.ibm.com>
 <20101023093630.GA3036@zhy>
 <4CC563A9.3020308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4CC563A9.3020308@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 04:32:01PM +0530, divya wrote:
> http://lkml.org/lkml/2010/10/13/67 resolves the issue.
> 
> But this is not a part of 2.6.36-git6 , when will it be pulled into the upstream?

That patch is splited into two parts.
The lockdep one is 4ba053c04aece1f4734056f21b751eee47ea3fb1 upstream.
The mousedev one is taken by Dmitry Torokhov(Cc'ing)

Thanks,
Yong
