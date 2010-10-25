Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab0JYOPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:15:24 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59960 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab0JYOPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WYnzfJKOnL8VQc5sS9gjgn17bAkRv96/TfT+97c4XSgypom166gcIuZO9zYWFUDuYZ
         rshp2XKWZPa2++fkK64v9dsEUwONdJib7Pb+NadC2gJCm3bMTWB6yoq3+x9JE+UFU/HT
         kOa0cnlcmexNnnMqd446mk5dYf0nnOS2ufiS8=
Date: Mon, 25 Oct 2010 22:15:10 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: divya <dipraksh@linux.vnet.ibm.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: BUG with the kernel version 2.6.36-rc1 on power machine
Message-ID: <20101025141510.GA5875@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <4CC13B2C.7090908@linux.vnet.ibm.com>
 <4CC13FFF.7040200@linux.vnet.ibm.com>
 <AANLkTikmpohofzO_dV_Dv8EfcEMsyy4cdhGMUD-PAFO3@mail.gmail.com>
 <1287774802.19497.1.camel@subratamodak.linux.ibm.com>
 <20101023093630.GA3036@zhy>
 <4CC563A9.3020308@linux.vnet.ibm.com>
 <20101025135710.GA5461@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101025135710.GA5461@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 09:57:10PM +0800, Yong Zhang wrote:
> On Mon, Oct 25, 2010 at 04:32:01PM +0530, divya wrote:
> > http://lkml.org/lkml/2010/10/13/67 resolves the issue.
> > 
> > But this is not a part of 2.6.36-git6 , when will it be pulled into the upstream?
> 
> That patch is splited into two parts.
> The lockdep one is 4ba053c04aece1f4734056f21b751eee47ea3fb1 upstream.
> The mousedev one is taken by Dmitry Torokhov(Cc'ing)

Just notice Dmitry has sent pull request to Linus.
You can also get the mousedev one here:
http://git.kernel.org/?p=linux/kernel/git/dtor/input.git;a=commit;h=f74eef95e33a07379aa2b950c7f313cbfd55ebbe

Thanks,
Yong
