Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab0DUWtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:49:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab0DUWtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:49:52 -0400
Message-ID: <4BCF80F2.2010906@redhat.com>
Date: Wed, 21 Apr 2010 18:49:22 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: John Stoffel <john@stoffel.org>, Hedi Berriche <hedi@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
References: <4BCE579C.5070100@sgi.com> <4BCE5A73.3000904@sgi.com> <20100421102350.4c222e6b@lxorguk.ukuu.org.uk> <20100421165934.GN16427@zorg.emea.sgi.com> <4BCF336B.1050706@redhat.com> <19407.20109.308816.104856@stoffel.org> <20100421193350.GU16427@zorg.emea.sgi.com> <19407.23456.469074.256306@stoffel.org> <20100421222414.GA26241@suse.de>
In-Reply-To: <20100421222414.GA26241@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 06:24 PM, Greg KH wrote:

> Tejun's work has much better long term potential, but this is still an
> issue for large #cpu systems, which we want Linux to support well.  This
> isn't a "specialized niche" for Linux, at all, Linux pretty much
> dominates this hardware area, and it would be nice to ensure that this
> continues.

Yes, the pid_max patch seems like a decent stop gap for
distro kernels right now.  However, Tejun's work is
probably a more appropriate path forward.
