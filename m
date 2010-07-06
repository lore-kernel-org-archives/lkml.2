Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0GFRYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 13:24:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50852 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab0GFRYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 13:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ioA2V6anJxP+w03VZfcK9xquvv/nH4ZRyMTlIJ5kBbF+/CASIMAEXHWqYPXEaQY8uV
         hFDHFvmzaOiz8XdxLDaMpUvCF0rTvyBqURcgfZc5QxOdxhsjV7l7BVyC/hwEomUGxb/y
         Un4mhycgp4Gi9ms+XjkKLxH3RITh9coDhcB7E=
Message-ID: <4C3365A5.5010605@gmail.com>
Date: Tue, 06 Jul 2010 10:19:33 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: linux-crypto@vger.kernel.org, davem@davemloft.net, jkosina@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]crypto:hifn_795x.c Fix warning: variable 'ctx' set but
 not used
References: <20100706070355.GA14626@gondor.apana.org.au>
In-Reply-To: <20100706070355.GA14626@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This certainly does not look right! Returning with IRQs disabled
> is considered to be rude.
>
> I believe the right answer is to delete the line initialising ctx.
>
> Thanks,

o.k. hopefully this is correct this time, resent with the following 
change. let me know if it's legit or not..

Justin P. Mattock
