Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0IMLC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 07:02:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39070 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab0IMLC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 07:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ub9aJfzVYP4rhTB+gjYJlN0EHqbrN/z/q1AmFEjtXIvxMYP0djAfTW3CQcFg93Lqja
         tmy3lTWyxi6Byk9KPbaKjRDGvMPyx4r72ITqrP6gC3S4wIE55Um2DchEBsmdOBhwTKd1
         LFDLmkx7Zp9EzpyMMd61CFzUaNNoOPU0oV8hI=
MIME-Version: 1.0
In-Reply-To: <201009131256.36523.marek.vasut@gmail.com>
References: <4C8DFA84.4040501@gmail.com>
	<201009131256.36523.marek.vasut@gmail.com>
Date: Mon, 13 Sep 2010 15:02:24 +0400
Message-ID: <AANLkTikotyfyvJ76-kemy_NPGEJifEF8PcuWuiomuc_2@mail.gmail.com>
Subject: Re: [PATCH v2] AT91: Add flexibity board support
From: Maxim Osipov <maxim.osipov@gmail.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Antonio R. Costa" <costa.antonior@gmail.com>,
        Ernst Schwab <eschwab@online.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, Sep 13, 2010 at 2:56 PM, Marek Vasut <marek.vasut@gmail.com> wrote:
> Dne Po 13. září 2010 12:18:44 Maxim Osipov napsal(a):
>
> btw. don't you want to modularize this code a bit ? check how mach-pxa/z2.c or
> mach-pxa/vpac270.c is done for example.
>

No, all functionality is needed in the product, so I do not think
modularization is necessary.

Kind regards,
Maxim
