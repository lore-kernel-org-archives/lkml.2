Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967110Ab2EQP2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:28:33 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:13602 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966647Ab2EQP2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:28:31 -0400
Message-ID: <4FB1950C.9000304@suse.com>
Date: Mon, 14 May 2012 16:28:12 -0700
From: Lee Duncan <lduncan@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kai.makisara@kolumbus.fi, jeffm@suse.com
Subject: Re: [PATCH 3/5] st: get rid of scsi_tapes array
References: <4FB476F3.5010404@suse.com> <1337240130.2926.4.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1337240130.2926.4.camel@dabdike.int.hansenpartnership.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, understood.

On 05/17/2012 12:35 AM, James Bottomley wrote:
> On Wed, 2012-05-16 at 20:56 -0700, Lee Duncan wrote:
>> st currently allocates an array to store pointers to all of the
>> scsi_tape objects. It's used to discover available indexes to use as the
>> base for the minor number selection and later to look up scsi_tape
>> devices for character devices.
>>
>> We switch to using an IDR for minor selection and a pointer from
>> st_modedef back to scsi_tape for the lookups.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> Reviewed-by: Lee Duncan <lduncan@suse.com>
> 
> This can't be Reviewed-by either.  The signoff chain has to follow the
> transmission path of the patch.  If you send me Jeff's patches, you have
> to add a signoff because you're a direct part of the transmission path.
> If Jeff sends me them, then he can give you Reviewed-by because you're
> not then in the direct transmission path.  (Signoff is supposed to imply
> reviewed by anyway, so the tagging is correct in either case).
> 
> James
> 
> 
> 

-- 
Lee Duncan

