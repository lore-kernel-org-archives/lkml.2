Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab0KHKmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:42:51 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58441 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab0KHKmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:42:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eb2nI+JDZRZuIRFYQI/vrgGY3EykfjQF7fwGRXyXhnyyAf0EAOQZsBa+NRuG3zFZgi
         mUMOCnAoV9DHi+Fxtwcv+rTwvrMoV8Jg/rmui+L9F9mFrXFdyexXHBUCrrg08ZtwCR6E
         Nq2VlTVIE4Xuji7aqNKzaoVOP5jnJN4YCLOg8=
MIME-Version: 1.0
In-Reply-To: <4CD51847.20306@gmail.com>
References: <4CD51847.20306@gmail.com>
Date: Mon, 8 Nov 2010 18:42:48 +0800
Message-ID: <AANLkTimAMAmdmJBELBmnZNycBv8nOwEf+b3EUCHEiF_9@mail.gmail.com>
Subject: Re: [PATCH 02/16 v2] pramfs: super block operations
From: yidong zhang <zhangyd6@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, tim.bird@am.sony.com,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Marco
> +       retval = 0;
> + out:
> +       if (retval && sbi->virt_addr) {
> +               iounmap(sbi->virt_addr);
> +               release_mem_region(sbi->phys_addr, initsize);
> +       }
> +
> +       return retval;
> +}
 Should add kfree(sbi) here in case of  failure?
