Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab0DGQ4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:56:46 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:51774 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118Ab0DGQ4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:56:35 -0400
X-Greylist: delayed 1339 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2010 12:56:34 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GEDvwxC3+Lyv3DLS5g/wRl7JeJetsVhU9zF8qdtP8eTLI7S52jVE7V0SAdDI47ebSk
         H9AgqkSxesNcQfxCHe23TAbywKSEEWZqvNmgegizPi1EP3PADEmnjfFSrevtj2cSM4hV
         94l02nMpC1CmunWG1d6aq22bk8vYZ+A3C8o8Q=
MIME-Version: 1.0
In-Reply-To: <20100407152254.GQ23670@thunk.org>
References: <j2oac8f92701004070651xf35cfb9bsedcdd25169427515@mail.gmail.com>
	 <20100407152254.GQ23670@thunk.org>
Date: Thu, 8 Apr 2010 00:56:30 +0800
Message-ID: <g2xac8f92701004070956j9b70ec83x215f444b21650949@mail.gmail.com>
Subject: Re: [PATCH] ext4: BUG_ON could be triggered in ext4_mb_normalize_request()
From: jing zhang <zj.barak@gmail.com>
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/7, tytso@mit.edu <tytso@mit.edu>:
> On Wed, Apr 07, 2010 at 09:51:46PM +0800, jing zhang wrote:
>> From: Jing Zhang <zj.barak@gmail.com>
>>
>> Date: Wed Apr 7 21:34:48     2010
>>
>> BUG_ON at [line: 2912] could be triggered,
>>      if (pa->pa_deleted == 0 && pa->pa_free == 0)
>> as checked at [line: 3111] and [line: 3122].
>
> Please don't use line numbers, as line numbers may not be the same in
> your version and my version.  Secondly, please give a high-level
> scenario where this could happen.
>
> 					- Ted
>

My duty is not over, and I think, more check seems necessary.

          - zj
