Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab1JaRTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:19:18 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:64612 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861Ab1JaRTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=vjItZZ
	95zb8d5U6zVUYjAbGaFigJw2+KAFfN09fqP0GztUwMv2Ep2UzeEPlBzUpgnvpMir
	i1IaGtYd/3LRJmSHltgmdSbi+EGCPq2uffDF1dOm9pN67VpfxGniuc9Lfobpgzgw
	d0tc80zT2CP+lKjDC4cnrZS7Bk3TfCV4DHyX0=
From: Junio C Hamano <junio@pobox.com>
To: Stefan =?utf-8?Q?N=C3=A4we?= <stefan.naewe@atlas-elektronik.com>
Cc: "git\@vger.kernel.org" <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git 1.7.8.rc0
References: <7vfwi9rc0g.fsf@alter.siamese.dyndns.org>
 <4EAEAE13.50101@atlas-elektronik.com>
Date: Mon, 31 Oct 2011 10:19:12 -0700
In-Reply-To: <4EAEAE13.50101@atlas-elektronik.com> ("Stefan =?utf-8?Q?N?=
 =?utf-8?Q?=C3=A4we=22's?= message of "Mon, 31 Oct 2011 15:17:55 +0100")
Message-ID: <7v8vo1qdtb.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 74A5FAC0-03E4-11E1-9430-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Näwe <stefan.naewe@atlas-elektronik.com> writes:

>>  * HTTP transport did not use pushurl correctly, and also did not tell
>>    what host it is trying to authenticate with when asking for
>>    credentials.
>>    (merge deba493 jk/http-auth later to maint).
>
> This seems to break pushing with https for me.
> It never uses values from my '~/.netrc'.
> I'll come up with a detailed scenario later.

Thanks.

I have been pushing my updates out to code.google.com via authentication
token stored in ~/.netrc over https, so it would be nice to see what
breaks for you that works for me. There probably is something subtly
different.
