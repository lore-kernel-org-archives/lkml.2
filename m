Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2KLCsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 21:48:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:53920 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2KLCsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 21:48:09 -0500
Message-ID: <50A07169.6090201@infradead.org>
Date: Sun, 11 Nov 2012 19:47:53 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
CC: linux list <linux-kernel@vger.kernel.org>
Subject: Re: acked-by meaning
References: <CACnwZYc4xY5r_oxu36URsSHen1kHDiStULMyB2LrZB+Eg=FF2g@mail.gmail.com>
In-Reply-To: <CACnwZYc4xY5r_oxu36URsSHen1kHDiStULMyB2LrZB+Eg=FF2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 05:40 PM, Thiago Farina wrote:

> Hi,
> 
> What is the meaning of 'Acked-by:' line? Is the same of LGTM? How it
> differs from 'Reviewed-by:'?

Reviewed-by: is stronger than Acked-by:.
If someone replies with Reviewed-by, they also accept some
responsibility for fixing any problems that the patch might
introduce after it is merged.
Acked-by just means agreement with the patch.

> If someone acks a patch (can anybody acks or just the maintainer?),
> does it mean that he will also apply the patch to his tree?


Anybody can reply to a patch with Acked-by.
No, it doesn't mean that the replying/acking person will apply
the patch to any tree.


Have you read what Documentation/SubmittingPatches and
Documentation/development-process/5.Posting and 6.Followthrough
say about Acked-by?

-- 
~Randy
