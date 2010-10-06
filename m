Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab0JFMRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 08:17:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:54549 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab0JFMRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 08:17:18 -0400
Message-ID: <4CAC68C1.1070706@windriver.com>
Date: Wed, 06 Oct 2010 07:17:05 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: manual merge of the kgdb tree with the input tree
References: <20101006130436.45d8a96a.sfr@canb.auug.org.au>
In-Reply-To: <20101006130436.45d8a96a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2010 12:17:06.0941 (UTC) FILETIME=[649422D0:01CB6550]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 09:04 PM, Stephen Rothwell wrote:
> Hi Jason,
>
> Today's linux-next merge of the kgdb tree got a conflict in
> drivers/char/sysrq.c between commit
> 1966cb225c6f9040ca163802cbd052c393d4448f ("Input: sysrq - add locking to
> sysrq_filter()") from the input tree and commit
> 02307772717c91a108aca2e999bbc586a85d06a2 ("sysrq,keyboard: properly deal
> with alt-sysrq in sysrq input filter") from the kgdb tree.
>
> Just context changes.  I fixed it up (see below) and can carry the fax as
> necessary.
>   

Thanks Stephen,

Hopefully I can get the sysrq / keyboard patches out of my tree and into
Dmitry's tree which should fix the problem by design. :-)

Thanks,
Jason.
