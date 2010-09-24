Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab0IXV32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:29:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234Ab0IXV31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:29:27 -0400
Date: Fri, 24 Sep 2010 14:29:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Brian C. Huffman" <bhuffman@graze.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intel DP43BF MB - No PCI Devices detected
Message-Id: <20100924142924.cf074205.akpm@linux-foundation.org>
In-Reply-To: <4C759125.8030008@graze.net>
References: <4C759125.8030008@graze.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 17:54:45 -0400
"Brian C. Huffman" <bhuffman@graze.net> wrote:

>   I have searched and found no previous posts on this topic.  Using the 
> 2.6.36-rc2-git3 (and many before that rev), the kernel doesn't see my 
> PCI devices.  They can be seen with dmidecode but do not show up with 
> lspci (and are not mentioned on boot up).

Is this still happening?

Do you know when it started happening?  Was 2.6.35 OK?  2.6.34?

> 
> ...
>
> What can I do to further troubleshoot this?
> 

I guess that capturing the bootup logs for both working and non-working
kernels wold be a good start, thanks.

