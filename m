Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab0GGTeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 15:34:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49127 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab0GGTeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 15:34:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aRxaURb+aRaOiTaR0v5n08sEuNjyKmNE48rFFLRxpa+D7kyzwAY/XHIf027pd7QFAd
         iqm2UnvpULVdVaICEb9GSYc7xY/BG00zdQ7aX0lOB/AmAq+DH9+ieAdKpNOuhlHBGV0I
         +y8uI0gDw6I+RWU03fI8W4JHxuWijWNYh6ajA=
MIME-Version: 1.0
In-Reply-To: <4C2B960A.7090503@colorfullife.com>
References: <alpine.DEB.2.00.1006180940140.11575@router.home>
	<20100621200118.GA4021@nb-core2.darkstar.lan>
	<4C223657.3030507@colorfullife.com>
	<AANLkTimE_BeA3yiCovC0ckn_MbbH3lpgctLD8zD5ir6j@mail.gmail.com>
	<AANLkTinw8qzAkHTNB05PqfWMQmuya1Dq6AZCgz2nWx6_@mail.gmail.com>
	<4C251AFF.70803@colorfullife.com>
	<AANLkTilm19O8nPGHSzExdCOPWR2Cridxq_sjs_uRkd8E@mail.gmail.com>
	<4C2620F4.7030900@colorfullife.com>
	<AANLkTikSh0FZYPppDcF2YDoyDBkIZcAdTBj7iN_9Cta4@mail.gmail.com>
	<4C2B960A.7090503@colorfullife.com>
Date: Wed, 7 Jul 2010 21:34:10 +0200
Message-ID: <AANLkTinbbKWxOAXg497aYEG56-TovX8eA8ZbcwdPfkUO@mail.gmail.com>
Subject: Re: 2.6.35-rc3: System unresponsive under load
From: Luca Tettamanti <kronos.it@gmail.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Andrew Morton <akpm@linux-foundation.org>,
       maciej.rutecki@gmail.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 9:07 PM, Manfred Spraul
<manfred@colorfullife.com> wrote:
> Attached is a new idea, could you try it with your httpd test?

With kernel 2.6.35-rc3 your patch does not make any difference.
 2.6.35-rc4, however, works fine with either one of your patches (yes,
I've checked multiple times).

Luca
