Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0DUNZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 09:25:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60139 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab0DUNZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:25:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CAjRlXAoydBSL+8ci71OJiHWIqvdo3bxBGN7Vx5aMgBzK2ZoWw2fVkk3ihXilLTeLA
         HR09sFp05WMb3pSIMNyohoIvF/ASf3K8XjJ9narRw0G6CpanfakpQsxMuxD9aIOS76/u
         ff+0rmPc4N1gR/Q0MBCp7svj8cnrGLZWBmfYQ=
Message-ID: <4BCEFCEA.8080509@gmail.com>
Date: Wed, 21 Apr 2010 06:26:02 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Whitespace Coding style fixes.
References: <1271833331-26973-1-git-send-email-justinmattock@gmail.com>	 <u2mb6fcc0a1004210003v5867afcfw4b112766a6951043@mail.gmail.com>	 <4BCEA499.6000308@gmail.com> <1271835281.1730.274.camel@Joe-Laptop.home>
In-Reply-To: <1271835281.1730.274.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 12:34 AM, Joe Perches wrote:
> On Wed, 2010-04-21 at 00:09 -0700, Justin P. Mattock wrote:
>> On 04/21/2010 12:03 AM, Alexey Dobriyan wrote:
>>> You screw up git-blame.
>> how does this patch screw it up?
>
> Alexey just doesn't like whitespace patches.
>
> Whitespace patches don't really "screw up" git blame.
>
> git blame displays the current version of a file
> with line-by-line commits and the date each line
> was last modified.
>
> So whitespace changes make it harder to find which patch
> introduced the last logical change for a particular line.
>
> A more interactive git blame with history backtracking
> might help keep Alexey happier but who knows for sure...
>
>


ahh.. so after adding this patch,
and committing it in my branch the doing
git blame security/commoncap.c
only shows something from James Morris instead
of what my change had brought.

Alright I can see why it screws things up..
I'll not (L)indent the whole tree then...

Justin P. Mattock
