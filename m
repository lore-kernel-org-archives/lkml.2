Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab1H2X3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:29:40 -0400
Received: from natasha.panasas.com ([67.152.220.90]:59546 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab1H2X3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:29:38 -0400
Message-ID: <4E5C20A7.9040603@panasas.com>
Date: Mon, 29 Aug 2011 16:28:39 -0700
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [uml-devel] [PATCH 8/9] um: fix strrchr problems
References: <1314634419-24766-1-git-send-email-richard@nod.at> <1314634419-24766-9-git-send-email-richard@nod.at> <20110829142705.5be82d7c.akpm@linux-foundation.org> <4E5C06DF.60508@nod.at> <20110829221230.GP2203@ZenIV.linux.org.uk> <4E5C0F9F.5000405@nod.at> <20110829221922.GQ2203@ZenIV.linux.org.uk> <4E5C11D5.4020404@nod.at>
In-Reply-To: <4E5C11D5.4020404@nod.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2011 03:25 PM, Richard Weinberger wrote:
>>
>> Try to build it static...
> 
> I'm building most of the time static.
> Using defconfig and
> CONFIG_STATIC_LINK=y
> it builds fine here (x86_64 and i386)
> 
> Thanks,
> //richard

With some switches and optimization gcc might turn strrchr
into a built-in inline.

What option turns off all optimizations? It might fail then.

Boaz
