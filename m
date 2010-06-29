Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0F2NdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:33:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:49963 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab0F2NdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:33:17 -0400
Message-ID: <4C29F61A.2090905@suse.cz>
Date: Tue, 29 Jun 2010 15:33:14 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, Alan <alan@clueserver.org>,
       linux-kernel@vger.kernel.org,
       =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khc@pm.waw.pl>
Subject: Re: [stable] [PATCH for stable] kbuild: Fix modpost segfault
References: <20100629094341.GA26045@sepie.suse.cz> <20100629125422.GB29243@kroah.com>
In-Reply-To: <20100629125422.GB29243@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.6.2010 14:54, Greg KH wrote:
> On Tue, Jun 29, 2010 at 11:43:42AM +0200, Michal Marek wrote:
>> Hi Greg,
>>
>> please add this to stable, it's a bug that started showing up with newer
>> gcc. The upstream commit is 1c938663d58b5b2965976a6f54cc51b5d6f691aa.
> 
> What -stable kernels do you want it applied to?  .27, .32, .33, and/or
> .34?

I'd say all of them. I just tried it and applies cleanly.

Michal
