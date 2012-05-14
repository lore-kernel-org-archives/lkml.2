Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967129Ab2EQP1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:27:30 -0400
Received: from nat.nue.novell.com ([195.135.221.2]:2377 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966647Ab2EQP12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:27:28 -0400
Message-ID: <4FB194CB.70106@suse.com>
Date: Mon, 14 May 2012 16:27:07 -0700
From: Lee Duncan <lduncan@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kai.makisara@kolumbus.fi, jeffm@suse.com
Subject: Re: [PATCH 1/5] st: Use static class attributes
References: <4FB476DD.4020107@suse.com> <4FB4782F.9080907@suse.com> <1337239966.2926.1.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1337239966.2926.1.camel@dabdike.int.hansenpartnership.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. I will resend.

On 05/17/2012 12:32 AM, James Bottomley wrote:
> On Wed, 2012-05-16 at 21:01 -0700, Lee Duncan wrote:
>> Sorry. This is actually
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> Reviewed-by: Lee Duncan <lduncan@suse.com>
>>
>> Apologies. The other patches in the set are labeled correctly.
> 
> Actually, no, in this case, I need a From: field at the top as well for
> the author.
> 
> You obviously used git to generate them, so either
> 
> git show --pretty=email
> 
> or
> 
> git format-patch -k
> 
> Will produce the right form
> 
> James
> 
> 
> .

-- 
Lee Duncan
SUSE Labs
