Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0H2NeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:34:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38007 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0H2NeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:34:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IcsPV0MgmV1H/ihkCmJMa8rW/prVGp/ptF6It/A/fN8O0G2uFqB7cpsBoSTf72g4RT
         pShiOaW7bNpkEaGerh3r8G22GMz8rLvS/KnpETaszbjKVI3wJ01LpsAwiDuTbGP2JrhP
         CVFXj+X6Db6RS7KcEqj4ya89JnlkjOGrS7BeM=
MIME-Version: 1.0
In-Reply-To: <20100818124755.GE4944@suse.de>
References: <AANLkTin5K=ii_ZhQ1hFm7wfcqfhdQhrUh-mXS7ZAy=h-@mail.gmail.com>
	<20100818124755.GE4944@suse.de>
Date: Sun, 29 Aug 2010 16:34:10 +0300
Message-ID: <AANLkTikCYn_i_UuPWOtFsdMghk_8H-myMZmfmdhaAFHN@mail.gmail.com>
Subject: Re: Staging drivers das08_cs.c compile error
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 3:47 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Aug 18, 2010 at 02:07:05PM +0300, Anca Emanuel wrote:
>> Linux 2.6.36-rc1 compile error:
>>
>> drivers/staging/comedi/drivers/das08_cs.c: In function
>> ?das08_pcmcia_config_loop?:
>> drivers/staging/comedi/drivers/das08_cs.c:225: error: ?struct
>> pcmcia_device? has no member named ?io?
>
> Yeah, thanks, a patch has already been sent to me for this, I'll get it
> to Linus soon.
>
> thanks,
>
> greg k-h
>

ping
