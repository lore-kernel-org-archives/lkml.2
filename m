Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0H2TDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 15:03:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45034 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab0H2TDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 15:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fjAzc6RajLdHCLM4wq2cMcFOurF+tos9h4/wfk1nWEdXwwPnY529hQaUX6p82gniPW
         TKXxKviHz5Vc6gjZYK2cDmrx0PCUjMv1nHfWmdvvix3sERwrYB9LUOXTPKlUoNRZAnVx
         0q0bM2kmkCL63BOaR1eWMkKHxc5RdCnT9pT4g=
MIME-Version: 1.0
In-Reply-To: <1283011478-27237-12-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-12-git-send-email-brgerst@gmail.com>
Date: Sun, 29 Aug 2010 22:02:03 +0300
X-Google-Sender-Auth: 0BgVAtmel6bkqqk7whPOGxp-zFM
Message-ID: <AANLkTikUVQWHxRKbfN2+e67kc+EfoN-C8Zg3YSkT+fqs@mail.gmail.com>
Subject: Re: [PATCH 11/11] x86: Remove PSHUFB_XMM5_* macros
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
> The PSHUFB_XMM5_* macros are no longer used.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Acked-by: Pekka Enberg <penberg@kernel.org>
