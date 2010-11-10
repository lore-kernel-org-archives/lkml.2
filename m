Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0KJPXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:23:31 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43752 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab0KJPX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:23:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=PHjRQMVhl49OTnIZwGPpkprGYxDloR5o2gUN23hKLz1tRQiBazjQ9SKGLduiqqkv5N
         9rHuoQFZ5X+5LPpjjvGMy3wsKkH1PfKl8KknGHDEgjg3ylwhMeBp9F1uJILNupeQ0X48
         GREyovclEY+66zSUVOCIwKccu/RI+w2ncPe+w=
Message-ID: <4CDAB8ED.7070609@gmail.com>
Date: Wed, 10 Nov 2010 16:23:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Damian Varayud <davarayud@gmail.com>
CC: gregkh@suse.de, harmonco@engr.orst.edu, sam.j.richardson@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Staging: comedi: fix brace coding style issue in
 ni_tio.c This is a patch to the ni_tio.c file that fixes up a brace, indentation
 and overlines warning found by the checkpatch.pl tool Signed-off-by: Varayud
 Damian Alfredo <davarayud@gmail.com>
References: <1289395215-2131-1-git-send-email-user@netbu>
In-Reply-To: <1289395215-2131-1-git-send-email-user@netbu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 02:20 PM, Damian Varayud wrote:
> @@ -291,21 +296,22 @@ static void __exit ni_tio_cleanup_module(void)
> 
>  module_exit(ni_tio_cleanup_module);
> 
>  struct ni_gpct_device *ni_gpct_device_construct(struct comedi_device *dev,
> -						void (*write_register) (struct
> -									ni_gpct
> -									*
> -									counter,
> -									unsigned
> -									bits,
> -									enum
> -									ni_gpct_register
> -									reg),
> -						unsigned (*read_register)
> -						(struct ni_gpct *counter,
> -						 enum ni_gpct_register reg),
> -						enum ni_gpct_variant variant,
> -						unsigned num_counters)
> +						void (*write_register)
> +						(struct ni_gpct *counter,
> +						 unsigned bits,
> +						 enum ni_gpct_register reg),
> +						unsigned (*read_register)
> +						(struct ni_gpct *counter,
> +						 enum ni_gpct_register reg),
> +						 enum ni_gpct_variant variant,
> +						 unsigned num_counters)

I don't think this looks anyhow saner. What about shifting it left like:
               void (*write_register)(struct ni_gpct *counter,
                        unsigned bits, enum ni_gpct_register reg),
               unsigned (*read_register)(struct ni_gpct *counter,
			enum ni_gpct_register reg),
	       enum ni_gpct_variant variant, unsigned num_counters)

regards,
-- 
js
