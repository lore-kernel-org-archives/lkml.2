Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab2A1Iew (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 03:34:52 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:37294 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab2A1Iev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 03:34:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=bPuxqhzfe7Fn365IQr+pbHmKBCPnfEG/
	/GYiIVpQyUlZHf0138gWcUw41wJgeGYQJ9xhZaD03StXp9lZ3FemXBZac+gNBccQ
	dgpMs/XaPzIstjftU6Eb3BzENf40q4cUpwjNYsL0FigpyQVdxqBsTVZp7sGOGNhF
	OSsT41IWk20=
From: Junio C Hamano <junio@pobox.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches for 3.3-rc1
References: <20120127230946.GA23528@kroah.com>
Date: Sat, 28 Jan 2012 00:34:48 -0800
In-Reply-To: <20120127230946.GA23528@kroah.com> (Greg KH's message of "Fri,
 27 Jan 2012 15:09:46 -0800")
Message-ID: <7v7h0cxm1j.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: F154A51C-498A-11E1-881D-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> I tried to create a signed tag for this pull request.  It's call
> "driver-core-3.3-rc1-bugfixes" in the repo below, but when I did:
>     git request-pull master git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ driver-core-3.3-rc1-bugfixes > msg.txt
>
> I got the text below, no signed tag with the wording that I added to it
> that I could see.  Now I am still using git 1.7.8.3, is that why?

Ehh, the older versions never expected people to ask a tag to be pulled in
the first place, so there is no way they would have known to unwrap the
tag and pasted its tag message in the output ;-).

The request-pull script in 1.7.9 has finally received some belated
love. Since mid 2009, it didn't get much updates that improve the user
visible experience.
