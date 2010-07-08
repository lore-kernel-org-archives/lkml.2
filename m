Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab0GHFrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 01:47:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47419 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab0GHFrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 01:47:23 -0400
Message-ID: <4C356669.6020700@suse.cz>
Date: Thu, 08 Jul 2010 07:47:21 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild
References: <20100707090808.GA23006@sepie.suse.cz> <AANLkTimWtisN1J3EBKcckQ6Ex6jCbfyVcZfeAYYIXmHy@mail.gmail.com>
In-Reply-To: <AANLkTimWtisN1J3EBKcckQ6Ex6jCbfyVcZfeAYYIXmHy@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.7.2010 18:41, Linus Torvalds wrote:
> On Wed, Jul 7, 2010 at 2:08 AM, Michal Marek <mmarek@suse.cz> wrote:
>> my last pull request broke LOCALVERSION for O=... builds, sorry about
>> that. The following commit fixes that (verified by Rafael and Stephen
>> who reported it. I really hope this is the _last_ kbuild thing for
>> 2.6.35.
> 
> Hmm. I already applied the patch you sent earlier. It's commit
> 7263e715c91f in my tree.

Ok, thanks. I didn't notice that the patch is already in your tree.

Michal
