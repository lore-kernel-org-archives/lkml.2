Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab0LMKZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:25:45 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45984 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab0LMKZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:25:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rMf6V6bm2s0jKQCdtzcidvQjo77CrZRAw5YIliMxOhADS4st7A8z4fa1hSoMlNT3Xf
         Bl/TQbS6Td9Jyhg44CUDI9GTqfsMUhdP7tvjvtjcSQ5X21KrJI5oHUYH4s+JJmuHgkiO
         brUNiqBccxbwnZOkzen3vCUKWzhwc4k1ZCXHM=
Date: Mon, 13 Dec 2010 18:25:29 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Uvarov <muvarov@gmail.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
Message-ID: <20101213102529.GA10907@cr0.nay.redhat.com>
References: <20101203111623.GA2741@redhat.com>
 <AANLkTi=Xvbi5M_cNRL=wC+uwksG08SiCyWcqdmwB_5TU@mail.gmail.com>
 <20101203171147.GA2299@redhat.com>
 <20101203175401.GE28603@hmsreliant.think-freely.org>
 <20101207105053.GA2803@redhat.com>
 <4CFE89FE.1090901@kernel.org>
 <20101208141942.GA2335@redhat.com>
 <4D00823A.9050808@kernel.org>
 <20101209124117.GA6032@redhat.com>
 <4D01377B.5070809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D01377B.5070809@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 12:09:31PM -0800, Yinghai Lu wrote:
>On 12/09/2010 04:41 AM, Stanislaw Gruszka wrote:
>> On Wed, Dec 08, 2010 at 11:16:10PM -0800, Yinghai Lu wrote:
>>>>> please check debug patches, and boot first kernel and kexec second kernel with "ignore_loglevel debug earlyprintk...."
>>>>
>>>> Second kernel does not print anything, so maybe it not even start.
>>>> Dmesg from primary kernel attached.
>>>>
>>>> Stanislaw
>>>
>>>
>>> please try attached debug patch.
>> 
>> With debug patch kdump kernel boot. Dmesg's from kdump and 
>> primary kernel in attachment.
>> 
>
>thanks.
>
>please check if this one works. it only put crashkernel low.
>

Yinghai, is it possible to add the debug patch to upstream too? For debugging
future kdump issues like this.

Thanks.
