Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab0CSCa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 22:30:26 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:44559 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0CSCaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 22:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rzydJ5Y02mLXE24K7LLoeIvdH0uMlOqWfoGeXI+3SDDz7NhphhL9zsaCvdSBcO+S3i
         6xwGwZT18wOZ84OEH2YQqNrxkpnQu9/v63STGsk3K1miTJf/n1y1c+cS4498u/AQt7xs
         Y1vmjHyfNpUqpUJale+Ovmv/PbBDZWHiXIzi0=
Date: Fri, 19 Mar 2010 03:30:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] percpu misaligned allocation
Message-ID: <20100319023027.GD22095@nowhere>
References: <4BA1F2BA.30604@kernel.org> <20100318.175413.183069013.davem@davemloft.net> <20100319013119.GB22095@nowhere> <20100318.185757.39197211.davem@davemloft.net> <4BA2DF0B.9080600@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA2DF0B.9080600@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 11:18:51AM +0900, Tejun Heo wrote:
> On 03/19/2010 10:57 AM, David Miller wrote:
> > I would use u64 so something like:
> > 
> > 	u64 [FTRACE_MAX_PROFILE_SIZE / sizeof(u64)]
> 
> <paranoid>DIV_ROUND_UP() would be safer than division</paranoid>
> 
> Thanks.


Ok, thanks guys, I'll try this out.

