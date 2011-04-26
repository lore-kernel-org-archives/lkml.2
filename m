Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1DZGFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:05:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44316 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab1DZGFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FZbuD2J0mdbFj6JxMModkRnrx43TgR3eNYIC/yxJ/mS8EcUsKl7EXpolPjIBeffwFm
         n61Ouwlwzl5qL6dXHc/Gs9mu0gpqPbadaUbJEpgHcBOK8b+fb7yEm+U7KEgLQ3vQ3SWD
         UpaKKwXFOYkrzdIOV3xAA6/mw2ZjRtGy57LPg=
MIME-Version: 1.0
In-Reply-To: <20110426055521.GA18473@localhost>
References: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
	<20110426055521.GA18473@localhost>
Date: Tue, 26 Apr 2011 14:05:12 +0800
Message-ID: <BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
Subject: Re: readahead and oom
From: Dave Young <hidave.darkstar@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 1:55 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Tue, Apr 26, 2011 at 01:49:25PM +0800, Dave Young wrote:
>> Hi,
>>
>> When memory pressure is high, readahead could cause oom killing.
>> IMHO we should stop readaheading under such circumstances。If it's true
>> how to fix it?
>
> Good question. Before OOM there will be readahead thrashings, which
> can be addressed by this patch:
>
> http://lkml.org/lkml/2010/2/2/229

Hi, I'm not clear about the patch, could be regard as below cases?
1) readahead alloc fail due to low memory such as other large allocation
2) readahead thrashing caused by itself

>
> However there seems no much interest on that feature.. I can separate
> that out and resubmit it standalone if necessary.
>
> Thanks,
> Fengguang
>



-- 
Regards
dave
