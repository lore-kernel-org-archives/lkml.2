Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab0DVIat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 04:30:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:39136 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab0DVIab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 04:30:31 -0400
Message-ID: <4BCED6B1.8060006@kernel.org>
Date: Wed, 21 Apr 2010 12:42:57 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.34-rc3 v2 Disable R_OK (Early ACK) on SII 3726 PMP
References: <g2ida824cf31004141843p41f7b21fz25927e3c6faeeed7@mail.gmail.com> <l2jda824cf31004201352y5fcdfa40g2ecb5dbb1706bf88@mail.gmail.com>
In-Reply-To: <l2jda824cf31004201352y5fcdfa40g2ecb5dbb1706bf88@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Apr 2010 08:29:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/20/2010 10:52 PM, Grant Grundler wrote:
> ping? Can this patch please be applied?
> 
> I was assuming this will show up here:
>    http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=shortlog;h=refs/heads/upstream-linus

This one should be applied to libata-dev.git/upstream which will be
merged into mainline during the next merge window.  I don't think
anything has changed in the PMP area since the merge window, so that
patch should apply to #upstream without too much problem (can't check
now).  Jeff, can you please apply this to #upstream?

Thanks.

-- 
tejun
