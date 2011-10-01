Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1JAT1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:27:25 -0400
Received: from 1wt.eu ([62.212.114.60]:33340 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab1JAT1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:27:18 -0400
Date: Sat, 1 Oct 2011 21:27:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: Shea Levy <shea@shealevy.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
Subject: Re: When to re-post or give up on a message
Message-ID: <20111001192706.GF18690@1wt.eu>
References: <4E8753F2.4080706@shealevy.com> <20111001205040.3b56bceb@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001205040.3b56bceb@stein>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 08:50:40PM +0200, Stefan Richter wrote:
> On Oct 01 Shea Levy wrote:
> > If a new thread is posted to the list without any response, how long 
> > should the poster wait before losing any expectation of a response? 
> > Under what circumstances should the poster then re-post, and when should 
> > he just give up on that thread? Sorry to have to ask this on the list, 
> > but I can't find it on the faq anywhere.
> 
> It depends on what it is about --- e.g. an urgent patch vs. an obscure bug.
> 
> But much more important than /when/ to repost is /how/ to repost.  If you
> did not get a response, then maybe
>   - the subject,
>   - the Cc list (subsystem mailinglists, people), or
>   - the description of your issue
> was lacking.  If you possibly can, find out more about the issue and where
> to send to before you repost.
> 
> It is better to repost (though not too frequently) than to give up.  But
> it is *much better* to repost with better researched and explained
> information (and, if applicable, with better Cc list) than to repost the
> same message.

And just for the record, here are a few additional hints (which don't
particularly apply to Shea's message, I found it and it was correct) :

  - don't write the subject in uppercase, that's used by spammers only
  - use a correct "From" field, not one looking like a spam or a young geek
    who wants to impress friends. This means you have first and last names.
  - put the most important information at the beginning of the subject, because
    a number of us check the list in a terminal lying in a corner. On my 80x25
    xterm, here's how your mail appears :

    10666     Sep 29 shea@shealevy.c (  25) Hang with "runaway loop modprobe net-pf-

    With the version-relevant parts on the left, it tends to attract the
    reader's eye more efficiently, especially for people who have made
    changes in this version :

    10666     Sep 29 shea@shealevy.c (  25) 3.0.4 regression: runaway loop modprobe net-pf-1

  - ensure your mail describes a problem and asks for clear questions. Do not
    just send an information expecting someone to comment on it.

Sometimes it's wise to wait 3-4 days if this is not urgent because someone
will feel concerned by your subject. If the problem is urgent for you,
indicate it in the message, but not in the subject as those are often
considered offensive. You will notice that many people read a lot of
mails without replying because they have nothing to say. If you're
clearly asking for some help, some readers may forward your message
to relevant people.

It's common to let bug reporters search a bit when they appear capable
of digging by themselves, because it's the only way to scale. That's
why it's important to clearly say when you've reached your limits and
are seeking for help. For instance, concerning your report, some readers
will wonder whether it's a 3.0-3.0.4 regression or a more general
2.6.39-3.0 regression, and they will naturally wait for you to report
this precision. Since you appear capable of trying different kernels,
this is something you should check yourself and report by responding
to your message.

Regards,
Willy

