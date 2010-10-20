Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab0JTMvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 08:51:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38766 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab0JTMvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 08:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AyXq5WDXBKpXeZnMPmHvQANkudc6CrxqE69Y7trm1P+xet1NXVcdoNZSf9CkLzMZtw
         j+WUnJTuB1o01+d/n8UrIk7+sWMo4DrHak5pXDCCD+1gWR4uAfdwJ96kg+L3IXkG5ofr
         vB4GCMTqfqoS5Mb6BYMHvAC4bZBFwxmpOKpJg=
MIME-Version: 1.0
In-Reply-To: <201010182135.09506.florian@openwrt.org>
References: <201010182135.09506.florian@openwrt.org>
Date: Wed, 20 Oct 2010 14:51:42 +0200
Message-ID: <AANLkTi=zj0Bns6eo40ksr52YKScarVvhMPNpxdT=Fjp7@mail.gmail.com>
Subject: Re: [PATCH v5] GPIO: add support for 74x164 serial-in/parallel-out
 8-bit shift register
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: David Brownell <david-b@pacbell.net>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, dbrownell@users.sourceforge.net,
        Juhos Gabor <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 9:35 PM, Florian Fainelli <florian@openwrt.org> wrote:
> From: Miguel Gaio <miguel.gaio@efixo.com>
>
> This patch adds support for generic 74x164 serial-in/parallel-out 8-bits
> shift register. This driver can be used as a GPIO output expander.

Could you add some documentation ? how to wire it both in soft and hard part?

Bastien
