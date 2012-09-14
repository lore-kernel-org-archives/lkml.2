Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2INElo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 00:41:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48075 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab2INElm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 00:41:42 -0400
Message-ID: <5052B576.8010500@zytor.com>
Date: Thu, 13 Sep 2012 21:41:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: Peter Jones <pjones@redhat.com>, jeremy.kerr@canonical.com,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        Matt Domsch <Matt_Domsch@Dell.com>, glin@suse.com
Subject: Re: [RFC,PATCH v2] efi: Add support for a UEFI variable filesystem
References: <1346910035.47691.188651047712.1.gpush@pecola>  <CAGLnvc9BXAW8F8WWyDxuF1_J+0np3uqUBmknuJewOJHhe-mxvw@mail.gmail.com>  <1347523843.596.30.camel@linux-s257.site>  <1347544333.6707.1.camel@eddie.install.bos.redhat.com> <1347594342.705.33.camel@linux-s257.site>
In-Reply-To: <1347594342.705.33.camel@linux-s257.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 08:45 PM, joeyli wrote:
> Hi Peter,
>
> 於 四，2012-09-13 於 09:52 -0400，Peter Jones 提到：
>> On Thu, 2012-09-13 at 16:10 +0800, joeyli wrote:
>>
>>> Do we have plan to create a new kobject add to /sys/firmware/efi for
>>> provide a fixed mount point to efivars fs?
>>> e.g. /sys/firmware/efi/efivars
>>>
>>> Or we just direct reuse current /sys/firmeware/efi/vars? But, that means
>>> we need think for the backward compatibility if choice reuse vars
>>> folder.
>>
>> I'm not sure that's a terribly large concern - if you haven't updated
>> your tools to use the new efivars, don't mount the new efivars.
>>
>
> Thanks for your comment!
>

I think it is wrong.  The new API should have a different path.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

