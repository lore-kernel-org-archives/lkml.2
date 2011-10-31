Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934714Ab1JaWtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:49:17 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:57941 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934617Ab1JaWtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:49:16 -0400
Date: Mon, 31 Oct 2011 18:49:05 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Junio C Hamano <gitster@pobox.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
Message-ID: <20111031224905.GQ16825@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Junio C Hamano <gitster@pobox.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>, git@vger.kernel.org,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Jeff Garzik <jeff@garzik.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike>
 <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org>
 <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <4EAF1F40.3030907@zytor.com>
 <CA+55aFxprv9JR4gtt_UDXheHR5G8PrUA3-Mj0CPsU6E5EzNYeg@mail.gmail.com>
 <4EAF2245.90308@zytor.com>
 <7vzkggok6u.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7vzkggok6u.fsf@alter.siamese.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 03:44:25PM -0700, Junio C Hamano wrote:
> So nobody is worried about this (quoting from my earlier message)?
> 
>    On the other hand, the consumers of "Linus kernel" may want to say that
>    they trust your tree and your tags because they can verify them with your
>    GPG signature, but also they can independently verify the lieutenants'
>    trees you pulled from are genuine.
> 
> A signed emphemeral tag is usable as means to verify authenticity in a
> hop-by-hop fashion, but that does not leave a permanent trail that can be
> used for auditing.

Oh, there are definitely people who worry about this.  They tend to be
security poeple, though, so the goal is how do we leave the permanent
trail in a way that doesn't generate too much noise or otherwise makes
life difficult for developers who don't care.

							- Ted
