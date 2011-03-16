Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab1CPG1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 02:27:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41183 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1CPG1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 02:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FGocGVsrQ17h2pMemell6JZqCIP7RA61rcWKpe2RLq87gu6MrWKq82NNbGytK9slCu
         9lmUuF5mfG5kZyVy8414trDEVaT65d7xEJ9DBpIMKn589eGbMYMe0gFnYfzFhBbtiyWT
         59G7c1DHifqBjdfmOBZCi03G1kWit5bOu8+4g=
MIME-Version: 1.0
In-Reply-To: <20110316042452.21452.qmail@science.horizon.com>
References: <1300244636.3128.426.camel@calx>
	<20110316042452.21452.qmail@science.horizon.com>
Date: Wed, 16 Mar 2011 08:27:05 +0200
X-Google-Sender-Auth: OZ1xM8TV4yS5rwFv_PL86H25ux4
Message-ID: <AANLkTi=eQn=G0E3XXp=MR2LErWrPJ8fZtr9RM3Q-Q=PP@mail.gmail.com>
Subject: Re: [PATCH 2/8] drivers/char/random: Split out __get_random_int
From: Pekka Enberg <penberg@kernel.org>
To: George Spelvin <linux@horizon.com>
Cc: mpm@selenic.com, herbert@gondor.hengli.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        penberg@cs.helsinki.fi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 6:24 AM, George Spelvin <linux@horizon.com> wrote:
>> You should really try to put all the uncontroversial bits of a series
>> first.
>
> Is that really a more important principle than putting related changes
> together?  I get the idea, but thought it made more sense to put
> all the slub.c changes together.

It it is more important because we might end up merging only the
non-controversial bits - at least for now.
