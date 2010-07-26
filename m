Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0GZJCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 05:02:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44880 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0GZJCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 05:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=sdF45t/05XP3UyWmakoBJApC/pKYKlxQgY6v9q9iNZwMHwjKNL6NTo1RcvZ05HjWQa
         2ukdAk55+JmFFfVQKcZDjmx1X/hXSciLU/2Frfe8bZZWbicCAsIXRGam303lhqw4YrN5
         VaL+cq0oWK8IcWEkWMOMriumaL+UePu01oxCE=
MIME-Version: 1.0
In-Reply-To: <1280129654.26844.3.camel@mola>
References: <1280129654.26844.3.camel@mola>
Date: Mon, 26 Jul 2010 11:02:05 +0200
X-Google-Sender-Auth: kgrqBRvzB-uhatGK98D7xudxFUE
Message-ID: <AANLkTimbM5=bEhtQrWj1H1nX3gqkdZskGz5KvA6WL3=v@mail.gmail.com>
Subject: Re: [PATCH resend] ab3100: fix off-by-one value range checking for 
	voltage selector
From: Linus Walleij <linus.walleij@stericsson.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/26 Axel Lin <axel.lin@gmail.com>:

> We use voltage selector as an array index for typ_voltages.
> Thus the valid range for voltage selector should be 0..voltages_len-1.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
