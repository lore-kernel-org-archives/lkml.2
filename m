Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab0C1NBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 09:01:33 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:32996 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0C1NBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 09:01:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pL15ItWb6IgV8VffdS00wkrz19L/iwsSgxrdYNA0PrFSokg/VrXkbiNmhsVMiA4FuY
         UY1iOpHgEhOLjOXmqfuLY/k0Mg73rIPA5fO2jNwKTV/hKc2pLxqGw/u5ZbRf4tQIOjVV
         cDv3ECRWDKAF3F4UglCkUll4Ko/SuWdMsY/+M=
Date: Sun, 28 Mar 2010 16:35:00 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jan III Sobieski <jan3sobi3ski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add random binaries to .gitignore
Message-ID: <20100328133500.GB3622@core2>
References: <4BAF4DAF.70609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAF4DAF.70609@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 02:38:07PM +0200, Jan III Sobieski wrote:
> +# random binary files
> +Documentation/filesystems/dnotify_test
> +Documentation/laptops/dslm
> +Documentation/timers/hpet_example
> +Documentation/vm/hugepage-mmap
> +Documentation/vm/hugepage-shm
> +Documentation/vm/map_hugetlb
> +arch/x86/boot/compressed/vmlinux
> +arch/x86/tools/test_get_len

This should go to per-directory gitiignores.
