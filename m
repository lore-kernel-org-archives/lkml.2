Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab0ETNr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 09:47:59 -0400
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:51457 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102Ab0ETNr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 09:47:58 -0400
Message-ID: <4BF53D8B.5090407@rsk.demon.co.uk>
Date: Thu, 20 May 2010 14:47:55 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Heinz Diehl <htd@fancy-poultry.org>
CC: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       lwoodman@redhat.com
Subject: Re: RFC: dirty_ratio back to 40%
References: <4BF51B0A.1050901@redhat.com> <20100520122919.GA3420@fancy-poultry.org>
In-Reply-To: <20100520122919.GA3420@fancy-poultry.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/10 13:29, Heinz Diehl wrote:
> On 20.05.2010, Larry Woodman wrote: 
> lwoodman@redhat.com
>> Increasing the dirty_ratio to 40% will regain the performance loss seen
>> in several benchmarks.  Whats everyone think about this???
> 
> These are tuneable via sysctl. What I have in my /etc/sysctl.conf is
> 
>  vm.dirty_ratio = 4
>  vm.dirty_background_ratio = 2
>  
> This writes back the data more often and frequently, thus preventing the
> system from long stalls. 
> 
> Works at least for me. AMD Quadcore, 8 GB RAM.
> 
get_dirty_limits uses a minimum vm_dirty_ratio of 5, so you can't set it
lower than that (unless you use vm_dirty_bytes).
But it's interesting that you find lowering the dirty_ratio helpful. Do
you have any benchmark results you can share?
regards
Richard
