Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1HZUyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:54:24 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:44999 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab1HZUyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=EJAR8JZEmHgJC8kJwlkYnFA0XkXkCdWX
	MbekX4NnTISUVNHb3RCvguB3V7r6tz+jB2ZOoeyFvMwF+dFZCNPeCyTsMo1UQwRZ
	qvNrGzdSKcq5JFUAZkK4b9AZo+ssQ9z5Z/ul+r8lLI0kLJ8p2apy9sBCv1BvvxBa
	44gNcZtCpL0=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Git Mailing List <git@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] .gitattributes: Enable cpp diff parsing for .[ch] files
References: <4E56CE8F.8080501@panasas.com>
 <CA+55aFxNXK-AJdrHBBycM5W632qUBi4E=jangcdRoefQiHzbug@mail.gmail.com>
Date: Fri, 26 Aug 2011 13:54:19 -0700
In-Reply-To: <CA+55aFxNXK-AJdrHBBycM5W632qUBi4E=jangcdRoefQiHzbug@mail.gmail.com> (Linus
 Torvalds's message of "Fri, 26 Aug 2011 13:27:43 -0700")
Message-ID: <7vfwkndhc4.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 927F8964-D025-11E0-A41E-1DC62E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Aug 25, 2011 at 3:37 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>> Add a .gitattributes file to the Linux tree to enable cpp parsing
>> of the source files.
>
> Hmm. I'm not entirely conviced. If people really think that the hunk
> description matters that much, maybe we should just instead improve on
> the automatic diff detection, and extend it from just binary-vs-text,
> to also do the common hunk-headers.
>
> After all, not having a diff pattern already *does* mean "automatic",
> so it would be just a rather trivial extension to that.

Not quite sure what you exactly mean by "extend it from just binary-vs-text".
Do you mean update buffer_is_binary() and add source language detection?

See also:

    http://thread.gmane.org/gmane.comp.version-control.git/180103/focus=180113

