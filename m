Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab1CRJV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 05:21:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39588 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab1CRJVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 05:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WvLUF5iCIEslZM/V9dgDX+jZNRI8lvOAdK4jMLT0TLuqsYm8uGN4TlVBww8ZWKpEv8
         F44iJyzC9K5F1+6EdqBG1hHS8bQgSNop+dgaSG1BnLM8f06OCIUw+b5+wesLxrEETJ9z
         S5cjQnaFWM1ZHu6t9fAYaSBsAt7XtcSaDFaFI=
MIME-Version: 1.0
In-Reply-To: <20110317213822.GA27980@kroah.com>
References: <20110317213822.GA27980@kroah.com>
Date: Fri, 18 Mar 2011 10:21:54 +0100
X-Google-Sender-Auth: GhNm9k1fLlQIbVOcQmRUBYxiwxo
Message-ID: <AANLkTikmuQ6bCn9wws9Z83gZXRz2gRRsWd+8Q34DqaFL@mail.gmail.com>
Subject: Re: [000/474] 2.6.33.8-longterm review
From: John Kacur <jkacur@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mgalbraith@suse.de, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 10:38 PM, Greg KH <gregkh@suse.de> wrote:
> Yeah, I know what you are thinking, "What, 2.6.33, are you crazy?"
>
> I'd prefer it if you didn't answer that question...
>
> Anyway, yes, a .33 kernel release, strange isn't it.
>
> Turns out there are a lot of people "stuck" on the 2.6.33 kernel series
> for a variety of valid reasons, not the least being the Real Time
> patchset.  So, in the copious spare time I have, I've been trying to
> keep up with the patches that have been applied to the different
> longterm and stable kernel trees and have been queueing them up for .33
> as well.
>
> Here's the result of that.  A 474 patch series that is bigger than most
> people ever want to review, or see in their inboxes.  Because of that,
> it is ONLY being sent to the stable-review@kernel.org mailing list.  If
> you want to see the individual patches, look at the git tree of the
> patch queue, or look at that mailing list.
>
> So, if you are using .33, please give this patch a test and let me know
> if I've messed up anything (hint, I think I did, it's up to you to
> figure it out, consider it a test to see if anyone actually cares about
> this kernel version.)
>
> If I missed anything that I should have in here, please let me know.
>
> Responses should be made by Saturday, March 19, 2011, 21:00:00 UTC.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>        kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.33.8-rc1.gz
> and the diffstat can be found below.
>

There is no rc1, so I assume
http://kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.33.8.bz2
is correct?
Which git tree do I want to use?

Thanks
John Kacur
