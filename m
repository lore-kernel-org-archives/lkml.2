Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0H2SZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:25:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34222 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab0H2SZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=b0USLnk93ksjf2D+fdNXZxzQYJqnPuCuQ4MWs+f4ST6Kwz4AE+3r6PE2ugQguhlWdf
         N9fRit9GOWWurTOCOp1q6z8aI5vdEtDUfopXAQtUydzl12/yOhWcQ9DnhLn358iNuTPq
         W+ZVCJI4QCr2DaqiZzjZhwgs7E10qE5nW80mA=
MIME-Version: 1.0
In-Reply-To: <1283011478-27237-2-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-2-git-send-email-brgerst@gmail.com>
Date: Sun, 29 Aug 2010 21:24:16 +0300
X-Google-Sender-Auth: 4EDlnLpBIctj1yvEVBBNcIrPJ0E
Message-ID: <AANLkTi=PBYiY_2w8ujOAGiE53oPz5X9zPZdACX=kNXR8@mail.gmail.com>
Subject: Re: [PATCH 01/11] x86: Use correct type for %cr4
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
> %cr4 is 64-bit in 64-bit mode (although the upper 32-bits are currently reserved).
> Use unsigned long for the temporary variable to get the right size.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
