Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab1KBS6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:58:18 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:53018 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065Ab1KBS6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=N38ibDY4Vy3CEZY0J+7IF5y4i2o/S0Vt
	MH/pT0NhxYMw90hjIThztZk/cQHhlQ8CoOsWJuEc272E1bZifOOY4X21uxFfNFiy
	qKK1AsYc9W8CgyhQmPNLn7WPCSF19Q6L0dr1taRIKwQ60tTeSCmmbwY3NFlfERCU
	oU99M0O4Nfw=
From: Junio C Hamano <gitster@pobox.com>
To: Michael J Gruber <git@drmicha.warpmail.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org>
 <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike>
 <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org>
 <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
 <4EB12122.7010803@drmicha.warpmail.net>
Date: Wed, 02 Nov 2011 11:58:13 -0700
In-Reply-To: <4EB12122.7010803@drmicha.warpmail.net> (Michael J. Gruber's
 message of "Wed, 02 Nov 2011 11:53:22 +0100")
Message-ID: <7v1utqjqre.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 9E4139C0-0584-11E1-914C-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael J Gruber <git@drmicha.warpmail.net> writes:

> The advantage of tags is that they can be added without rewriting the
> commit, of course.

And you did neither think about the downsides of tags, nor read what
others already explained for you?
