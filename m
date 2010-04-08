Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab0DHHsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 03:48:12 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:64405 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440Ab0DHHsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 03:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wrS8sNzGIEfU9g/nOtywhGjKbjiWJGGlzfzSWUDswVCub38UZv8TbXwSOuetf6RxUD
         TU97Pdl8m8Pq6J1IvdBERsKu5D9min+bJ/QgF5idDx/QdREscioN1RQmMY4/gYwczyAx
         MisNiKhnhBHv8CN2W7QCd3mzThGrn3w4vtCS0=
Message-ID: <4BBD8A31.2080007@iki.fi>
Date: Thu, 08 Apr 2010 10:48:01 +0300
From: =?ISO-8859-1?Q?Timo_Ter=E4s?= <timo.teras@iki.fi>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: powerpc boot failure
References: <20100408165848.38f75f40.sfr@canb.auug.org.au>	<4BBD81B3.3030500@iki.fi>	<20100408172316.e6ee451d.sfr@canb.auug.org.au>	<4BBD85ED.4090209@iki.fi> <20100408174549.2f45ceea.sfr@canb.auug.org.au>
In-Reply-To: <20100408174549.2f45ceea.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi,
> 
> On Thu, 08 Apr 2010 10:29:49 +0300 Timo Teräs <timo.teras@iki.fi> wrote:
>> You don't probably have any xfrm policies then. And that code should not
>> really get executed.
>>
>> Some of the changes touch globally visible structs, and inline functions.
>> Was this a clean rebuild? And did you update all kernel modules, also in
>> the initramfs?
> 
> Yes, the build is started from scratch and the kernel and modules are
> updated (this is our automated build and test system).
> 
> I have attached the config in case that is of use.

Thanks, I'll check some of the xfrm related configs.

Can you on running system do:
 ip xfrm policy

That shows if there's any policies due to e.g. ipsec or tcp-md5.
