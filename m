Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934662Ab1JaWjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:39:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52796 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab1JaWjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:39:16 -0400
MIME-Version: 1.0
In-Reply-To: <4EAF2245.90308@zytor.com>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <4EAF1F40.3030907@zytor.com> <CA+55aFxprv9JR4gtt_UDXheHR5G8PrUA3-Mj0CPsU6E5EzNYeg@mail.gmail.com>
 <4EAF2245.90308@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2011 15:38:54 -0700
X-Google-Sender-Auth: bdFGWdPoIiJkUf9mK0l9RyyOYJ0
Message-ID: <CA+55aFzedaAzzWfzhqVf8y8ZW0jeb56hZwdV3UodSp8Q_Qhc2A@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 3:33 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Didn't realize that... I guess I'm too used to named remotes.
>
> If so, just using a tag should be fine, no?

Yes, that's what I think. But the argument for using a separate
namespace is that
 (a) you never get confused
 (b) it would make it easier to make the 1:1 relationship between
branch names and these "pull request signature tags" without limiting
the naming of *normal* tags in any way
 (c) they do have separate lifetimes from "real" tags.

But seriously, I don't care about the *implementation* all that much.
If people want to use the crazy git "notes" capability, you can do
that too, although quite frankly, I don't see the point. What actually
matters is that "git push" and "git pull" would JustWork(tm), and
check the signature if one exists, without having to cut-and-paste
data that simply shouldn't be visible to the user.

I abhor the interface Ingo suggested, for example. Why would we have
stupid command line options that we should cut-and-paste? Automation
is for computers, not for people.

                          Linus
