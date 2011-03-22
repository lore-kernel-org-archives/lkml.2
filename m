Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab1CVCd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 22:33:29 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41778 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab1CVCd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 22:33:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VHF6nO9fe5/d/ahxshipfYb/OtEpO6zdhub8230SeBSu7hZyMHXsEoX78Wiqtvnder
         3Q/rql5zAuIl+coA743YTcjAKvkCY7wg+CBqtym13gmluan69oEzMAYgZe3d4n0pXXa5
         GBn+hnFqu08oddjE6DaO/DOqoQCB2cpohs4vY=
MIME-Version: 1.0
In-Reply-To: <1300708760-27910-1-git-send-email-torbenh@gmx.de>
References: <1300708760-27910-1-git-send-email-torbenh@gmx.de>
Date: Mon, 21 Mar 2011 19:33:26 -0700
X-Google-Sender-Auth: vBiopl1QR9GQ_zghQWmecArSwC0
Message-ID: <AANLkTikt95R5DT3cTkPbTia9PpJqUr55v_g_xVN_AQtf@mail.gmail.com>
Subject: Re: [PATCH 1/5] RFC genirq: Add IRQ timestamping
From: john stultz <johnstul@us.ibm.com>
To: Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 4:59 AM, Torben Hohn <torbenh@gmx.de> wrote:
> +       if (desc->status & IRQ_TIMESTAMP)
> +               getrawmonotonic(&desc->last_timestamp);
> +

I suspect you probably want some very clear comments around why you
chose timestamps based on CLOCK_MONOTONIC_RAW instead of
CLOCK_MONOTONIC. Likely in the code as well as in the commit log.

thanks
-john
