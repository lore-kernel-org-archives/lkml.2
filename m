Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2FTGbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 02:31:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43638 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab2FTGbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 02:31:33 -0400
MIME-Version: 1.0
In-Reply-To: <1340133595.27131.6.camel@joe2Laptop>
References: <1340132894-19003-1-git-send-email-devendra.aaru@gmail.com>
	<1340133595.27131.6.camel@joe2Laptop>
Date: Wed, 20 Jun 2012 12:01:32 +0530
Message-ID: <CAHdPZaPd7b=S0Yj+TRZUPkxzrLsZk+t=3dcBvJfac4P-W3rpXw@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] staging/rtl8192u: use for loop to assign bit
 shifted addr
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Wed, Jun 20, 2012 at 12:49 AM, Joe Perches <joe@perches.com> wrote:
> It's also got a bit of code duplication.
> Maybe something like:
>
>        if (priv->epromtype == EPROM_93c56) {
>                addr_len = 8;
>        else
>                addr_len = 6;
>
>        test_bit = 1 << (addr_len - 1);
>        for (i = 0; i < addr_len; i++) {
>                addr_str[i] = addr & test_bit;
>                test_bit >>= 1;
>        }
>
Ahhh, true.

V3 sending :-)

Thanks,
Devendra.
>
