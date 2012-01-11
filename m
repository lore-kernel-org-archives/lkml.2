Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2AKAPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 19:15:47 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:57194 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075Ab2AKAPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 19:15:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=U+fy3lhpsMIi4aEDFPFZo8eEKFKlKVQ3
	ao3Ip+Nx5K0BOID53kju+7Ba3iJ0yc+9//hoPZOqn6irlFgWrqE5s4v3sykBGyOj
	20sufYgub+hWdW/roTfFnVF7Zsc/llDxH6dLsbh1VSo/pRuVNhZ56NrRwX106nwq
	pqqgBNv/0FY=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL 05/11] SoC-level changes for tegra and omap
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
 <1326147171-13752-6-git-send-email-arnd@arndb.de>
 <CA+55aFyaOnJhrZOFnRiShH9kTeGEG8O8m9spvKF=c36QzjSvBA@mail.gmail.com>
 <20120110083933.GS21765@n2100.arm.linux.org.uk>
 <CA+55aFw15sw0PWtom88vJx1M45CLuvpZABQAxMOQ+xowz8Xq2A@mail.gmail.com>
Date: Tue, 10 Jan 2012 16:15:42 -0800
In-Reply-To: <CA+55aFw15sw0PWtom88vJx1M45CLuvpZABQAxMOQ+xowz8Xq2A@mail.gmail.com> (Linus
 Torvalds's message of "Tue, 10 Jan 2012 08:08:56 -0800")
Message-ID: <7vty438575.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 6721E52A-3BE9-11E1-AD6A-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, Jan 10, 2012 at 12:39 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>>
>> What about using -C instead (which implies -M, but also detects copies) ?
>
> I don't mind -C. It sometimes causes differences to what I see by
> default, but those differences are often interesting.
>
> But while it's interesting and relevant (unlike the non-rename patch
> that is just noisy), it also can hide lots of lines. With -C, you can
> get a diffstat that is actually fairly small, but that adds a lot of
> lines to the kernel (because somebody just copied large files with
> small changes), and if that happens I do want to see it as a "big
> change". So for me, the plain "just show renames" is a good default.
>
> So there is absolutely nothing wrong with -C. It's not what I use, but
> when I see that the diffstats don't match, it's easy to notice why,
> and that information is often fairly interesting, so I don't mind.

How about encouraging people to use stock "git request-pull" instead?

Then best/better practices can be captured as improvement patches to it,
instead of being spread as updates to many people's homebrew scripts, no?
