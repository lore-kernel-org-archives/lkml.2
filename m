Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2GYXlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:41:06 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:43451 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab2GYXlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=FoaHjSbJkhnumrglHx+tLIWR8yPd7UPG
	SWF9n452YcljCzWb9U2clrkzpAFAW2f3HyvJ08Bv9XvTjVa7FmL+ayj6o2anDic6
	52Qh2/ipwJlNsXfnJ0Ga9vlTmD175m/5TbzRwY+wB6j02s+d1Cijm2rS0A+62lMY
	q5/cFGj4BiM=
From: Junio C Hamano <gitster@pobox.com>
To: Stefan Beller <stefanbeller@googlemail.com>
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Rewrite Documentation/SubmittingPatches.
References: <CALbm-EbggDYBwEDmo6bjEO_=p0YEmLHASNkfAN5J-P4-mT-vgg@mail.gmail.com>
Date: Wed, 25 Jul 2012 16:41:01 -0700
In-Reply-To: <CALbm-EbggDYBwEDmo6bjEO_=p0YEmLHASNkfAN5J-P4-mT-vgg@mail.gmail.com> (Stefan
 Beller's message of "Fri, 13 Jul 2012 13:51:50 +0200")
Message-ID: <7vd33j9zoy.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 32183C76-D6B2-11E1-B9ED-01B42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Beller <stefanbeller@googlemail.com> writes:

> +5) "git format-patch HEAD~n"
> +
> +Use "git format-patch HEAD~n" to extract the last n patches from your
> +git repository. They will be be saved in textfiles named
> +
> +    0001-Introduce-new-Feature.patch
> +    0002-Improve-Documentation.patch

Two comments and a half-nit.


 - "--subject-prefix='PATCH v4'" is handy to know (since the
   workflow already assumes reviews and resubmissions in #11).

 - "--cover-letter" is handy to know when sending a multi-patch
   series.

 - "git format-patch -20" or "git format-patch origin" might be more
   familiar looking form than "git format-patch HEAD~20".
