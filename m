Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab0ICPUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:20:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50003 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0ICPUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:20:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=OYlfBnkCiw/1R8LEAiLvHGdLHyTM0eNBl38t7wZQitlicoZ1e3C6AUpD1/IedaWuOf
         ORO4tiWLwCjdCZ0EuZmb5S7ZxoqWcXcCeIVAtnAlKxsOIXmOkjrKOPfN/GFHjkYi6j+u
         BZsua98pidkhogPfdI+1RDfqjoIl5UmSlkzJ0=
Message-ID: <4C81122C.3050800@gmail.com>
Date: Fri, 03 Sep 2010 17:20:12 +0200
From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: =?UTF-8?B?TWlsb3NsYXYgVHJtYcSN?= <mitr@redhat.com>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org, "Ted Ts'o" <tytso@mit.edu>,
        Miloslav Trmac <mitr@redhat.com>
Subject: Re: [PATCH 01/19] User-space API definition
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <1282293963-27807-2-git-send-email-mitr@redhat.com> <20100903091842.GC28952@gondor.apana.org.au>
In-Reply-To: <20100903091842.GC28952@gondor.apana.org.au>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2010 11:18 AM, Herbert Xu wrote:
> I will be looking at this myself so please stay tuned and be ready
> to yell if you see that your requirements are not met.

On 08/20/2010 03:56 PM, Ted Ts'o wrote:
> So I'm bit at a list what's the whole point of this patch series.
> Could you explain that in the documentation, please?  Especially for
> crypto, explaining when something should be used, what the threat
> model is, etc., is often very important.

Hello,
 The document discussing the model, threats and design goals of this
framework can be found at:
https://www.cosic.esat.kuleuven.be/publications/article-1490.pdf

Comments and suggestions are welcome.

regards,
Nikos

PS. The existing (proposed) implementation covers about 90% of the
design goals, the rest are work in progress.
