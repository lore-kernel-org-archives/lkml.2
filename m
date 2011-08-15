Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab1HOA6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 20:58:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57135 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1HOA6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 20:58:16 -0400
Date: Mon, 15 Aug 2011 02:58:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Will Drewry <wad@chromium.org>
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, Solar Designer <solar@openwall.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        James Morris <jmorris@namei.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
Message-ID: <20110815005815.GX5782@one.firstfloor.org>
References: <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org> <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com> <20110814092028.GB14293@openwall.com> <01ba0cce-d28e-473e-be3a-7d3c8f185681@email.android.com> <20110814152729.GU5782@one.firstfloor.org> <4E47EB99.1020909@zytor.com> <20110815001841.GW5782@one.firstfloor.org> <CABqD9hYtu8RJC3H263Smej7zWASDjO6C82QdFxZ6q-KiQCdJZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABqD9hYtu8RJC3H263Smej7zWASDjO6C82QdFxZ6q-KiQCdJZg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps :) I wish it had landed after 9 revisions and at least two
> variant patches. Despite that, I think it's great to pull in
> additional requirements, like COMPAT locking, to make sure that the
> solution is really a good one.  It may also be that my entire original
> approach was wrong and should be revisited too.  Everyone's comments
> here and the proposed patch itself certainly have me thinking.

I didn't see anything wrong with it. Also the first try doesn't 
need to be perfect anyways, it can be always changed later.
 
How about you just repost it?

-Andi
