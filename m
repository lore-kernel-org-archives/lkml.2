Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab1CXSyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:54:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58436 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab1CXSyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=TzOGMLGzO53b/HkK99GTnn2TZPy00fGtqBif5wIX7B0iFF46csUcsSndh6SoqaqMb/
         6lqHVhXUA61cswbfWRsPF0iRaZyma2of+8RqOf1e1QlsyfEnEOTRYiJWbc2qA7/6Y6eG
         g8wT2XUYx2EURQPPvRBnf/BECI5Prfm0mkk24=
MIME-Version: 1.0
In-Reply-To: <1300980071-24645-5-git-send-email-jamie@jamieiles.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <1300980071-24645-5-git-send-email-jamie@jamieiles.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 24 Mar 2011 14:52:20 -0400
X-Google-Sender-Auth: 824Mb8sO4J0xV3GZcafvrHrqpZc
Message-ID: <AANLkTikzoNDaaz+4MAb7WzQ09+A4=7r=gpdt0ojc3Q2G@mail.gmail.com>
Subject: Re: [RFC PATCHv2 4/4] drivers/otp: convert bfin otp to generic OTP
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 11:21, Jamie Iles wrote:
> +config BFIN_OTP_WRITE_ENABLE
> +       bool "Enable writing support of OTP pages"
> +       depends on BFIN_OTP
> +       default n
> +       help
> +         If you say Y here, you will enable support for writing of the
> +         OTP pages.  This is dangerous by nature as you can only program
> +         the pages once, so only enable this option when you actually
> +         need it so as to not inadvertently clobber data.

if the generic layer is providing write enable access now, is this
still necessary ?  we could have a common OTP Kconfig i think for
"enable OTP write support".
-mike
