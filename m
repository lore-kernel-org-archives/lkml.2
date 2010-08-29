Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0H2SeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:34:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58745 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab0H2SeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:34:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VhPsYYD/3lswUh22lkogWNNbBYhTtwoz6qahyDWqO3WEKh0M3kez40qFePexecyAWj
         vDseqvyRBHWH2HB8HX+yq3mo7UdfrLkOodHWpIrxGKQnd7jC+GxF8ZP8ChAqTm7omjO9
         Ggxa9D0aediAQTFqAnrmFJ1sdfVYh/yxhZBCo=
MIME-Version: 1.0
In-Reply-To: <1283011478-27237-4-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-4-git-send-email-brgerst@gmail.com>
Date: Sun, 29 Aug 2010 21:32:59 +0300
X-Google-Sender-Auth: A7dpKtWh0EpQ_BUiuw7poN7JFec
Message-ID: <AANLkTikXeC--5PuuhmJgxDr8MAg97rC5OecsV3HNPz=g@mail.gmail.com>
Subject: Re: [PATCH 03/11] x86: Merge tolerant_fwait()
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
> Now that 32-bit can handle exceptions from the kernel, switch to using
> the 64-bit version of tolerant_fwait() without fnclex.  In the unlikely
> event an exception is triggered, it is simply ignored.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Why is 32-bit able to handle exceptions? Is that part of this series
or is it some existing commit in tip or linus?
