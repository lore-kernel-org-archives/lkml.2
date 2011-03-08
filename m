Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1CHMif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:38:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55754 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab1CHMid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:38:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AJS9K/ujwEeyOS9ugF1BMhc1t13123XzNrqfdxu1+6OpAw/fPJbcD8lh0DISp6xOHj
         3h1IRyiMbVdEWQgg9e92qaTwjeSdInWB9ZXKhUtlVCsE6LF90GYdofveaSttn16Ppedj
         JeYbav2WJbvLdSgIpoDhw87PEEspR2NBS7++4=
Subject: Re: [PATCH/RFC v2 1/3] Shared BCH ECC library
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ivan Djelic <ivan.djelic@parrot.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org
In-Reply-To: <181c9a1c88b781116615761109cccdf89ea877a1.2296641159.git.ivan.djelic@parrot.com>
References: <181c9a1c88b781116615761109cccdf89ea877a1.2296641159.git.ivan.djelic@parrot.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 14:37:05 +0200
Message-ID: <1299587825.2754.30.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I can put these to my l2-mtd-2.6 tree and l
On Mon, 2011-02-07 at 15:09 +0100, Ivan Djelic wrote:
>  #
> +# BCH support is selected if needed
> +#
> +# If the BCH library is always used with the same parameters
> +# m and t, you may select option BCH_CONST_PARAMS and provide
> +# default values for symbols BCH_CONST_M and BCH_CONST_T in
> +# your Kconfig code. This will enable extra compiler optimizations
> +# and provide better (up to 2x) encoding performance for small
> +# values of t, at the expense of supporting only a single (m,t)
> +# configuration.
> +#
> +config BCH
> +	tristate
> +
> +config BCH_CONST_PARAMS
> +	boolean
> +
> +config BCH_CONST_M
> +	int
> +	range 5 15
> +
> +config BCH_CONST_T
> +	int

Could you please re-work this and add useful "help" description to each
of these. You added some description to the comments, but it really
should be in the help text instead, may be even in a bit more verbose
form.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

