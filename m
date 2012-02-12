Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2BLVBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 16:01:54 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab2BLVBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 16:01:53 -0500
Message-ID: <4F3828BD.7070809@nod.at>
Date: Sun, 12 Feb 2012 22:01:49 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Cleanup headers files
References: <20120130192552.GL23916@ZenIV.linux.org.uk> <1328311063-17630-1-git-send-email-richard@nod.at> <20120204001431.GY23916@ZenIV.linux.org.uk> <4F2C7F7A.1090605@nod.at> <20120212202728.GR23916@ZenIV.linux.org.uk>
In-Reply-To: <20120212202728.GR23916@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.02.2012 21:27, schrieb Al Viro:
>> So, I pulled your work and merged it into my shiny new UML tree:
>> git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git
>
> Hmm...  I would really, really recommend you to clean the git history in that
> tree up.  As it is, you have
> 	* merge of that branch from um-headers
> 	* um: Switch to large mcmodel on x86_64
> 	* um: Serve io_remap_pfn_range()
> 	* 205 merges from Linus, from mid-April to late January.
> 	* mismerge from Linus on April 14; the diff between the result

Okay, I'll create a new tree. This one is definitely screwed.
Sorry for the inconvenience.

Thanks,
//richard
