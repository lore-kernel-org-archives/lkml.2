Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0KEALy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 20:11:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47939 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0KEALu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 20:11:50 -0400
MIME-Version: 1.0
In-Reply-To: <4CD286E4.8070802@kernel.org>
References: <20101104100914.GC25118@suse.de>
	<4CD286E4.8070802@kernel.org>
Date: Fri, 5 Nov 2010 08:11:49 +0800
X-Google-Sender-Auth: dZ1GbMc6zRf2rRIgg8jMmt5Z9bA
Message-ID: <AANLkTinC9gy1nXXp5ZZ=nF7Nta-TNmoSOmZYtzS6FApy@mail.gmail.com>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to reduce
 ease of attacking
From: Eugene Teo <eugeneteo@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 4, 2010 at 6:11 PM, Tejun Heo <tj@kernel.org> wrote:
> On 11/04/2010 11:09 AM, Marcus Meissner wrote:
>> Making /proc/kallsyms readable only for root makes it harder
>> for attackers to write generic kernel exploits by removing
>> one source of knowledge where things are in the kernel.
>>
>> Signed-off-by: Marcus Meissner <meissner@suse.de>
>
> I can't recall needing /proc/kallsyms when I wasn't root, so unless
> there's a compelling use case.
>
> Acked-by: Tejun Heo <tj@kernel.org>

Looks good to me too.

Acked-by: Eugene Teo <eugeneteo@kernel.org>

Eugene
