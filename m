Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab0JOTLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:11:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:32907 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401Ab0JOTLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:11:54 -0400
Message-ID: <4CB8A745.5020206@kernel.org>
Date: Fri, 15 Oct 2010 21:11:01 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tom Tucker <tom@opengridcomputing.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-nfs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Tom Tucker <tom@ogc.us>
Subject: Re: [PATCH linux-2.6.36-rc7] sunrpc/xprtrdma: clean up workqueue
 usage
References: <4CB87807.7050108@kernel.org> <20101015171132.GA18869@fieldses.org> <4CB89393.6000207@opengridcomputing.com>
In-Reply-To: <4CB89393.6000207@opengridcomputing.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 19:11:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2010 07:46 PM, Tom Tucker wrote:
>  On 10/15/10 12:11 PM, J. Bruce Fields wrote:
>> Tom, could you take a look?
>>
> This looks reasonable to me.
> 
> My bet is that it wasn't tested though due to hardware
> availability. I'll test it this weekend and let you know how it
> goes.

Yeap, only compile tested.  Testing would be much appreciated.

Thanks.

-- 
tejun
