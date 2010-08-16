Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0HPNRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:17:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59503 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0HPNRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=czBq3rmfZKK+HU4xLdBapPgVLwhIH/Zu4oF/50gEIKyMcUWje6ZGBzhLQONbGSkb/X
         MRvb5oIm+d+9gyyg+CkL9PLez/NPpJpdNFqc4IB+7ff3r3lNGn9yp6PZ+Jcbbs8uAKgr
         TDS8B8pAQc0W4rauxGbfqDgY4DDKxiS+CfbiE=
Message-ID: <4C693A6F.4000501@gmail.com>
Date: Mon, 16 Aug 2010 14:17:35 +0100
From: Andrew Benton <b3nton@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b4pre) Gecko/20100808 Shredder/3.2a1pre
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fixes for using make 3.82
References: <4C6936120200007800010064@vpn.id2.novell.com> <20100816114131.GA7122@merkur.ravnborg.org> <4C6942D102000078000100C9@vpn.id2.novell.com>
In-Reply-To: <4C6942D102000078000100C9@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/10 12:53, Jan Beulich wrote:
>>>> On 16.08.10 at 13:41, Sam Ravnborg<sam@ravnborg.org>  wrote:
>> Added: Michael Marek (kbuild maintainer) + linux-kbuild.
>>
>> I assume this fixes firmware build reported by Andrew Benton (cc:ed).
>
> Yes, it does (I had observed the same, which prompted the fix).
>

I can confirm that the patch fixes the problem, I can compile the kernel 
with make-3.82.
Many thanks.

Andy
