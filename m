Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab2BAFAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 00:00:22 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:48369 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab2BAFAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 00:00:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=FDwpeLxyXbPSz2h4Sg74Y3or7jrBDdN4
	Zam1kx7MdYa6xuTSzWprLP80oVKY5cgJanOx0BrYfp7sLkiYnt2azP5Sojbect+z
	YXjWqBd5vrEoCEclduChFY6X5F6MoFfBv5pTde+B10Sq4uIZ5ikrVRvyAXg+4oFT
	7iT2JOP4uCk=
From: Junio C Hamano <gitster@pobox.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: Regulator update for 3.3
References: <20120130134223.GG4882@opensource.wolfsonmicro.com>
 <CA+55aFyoTP3G_x9KzN_cdDYUxRGTBBdoRVT56nFODkqukog7aQ@mail.gmail.com>
 <20120130174345.GN4882@opensource.wolfsonmicro.com>
 <CA+55aFxPivRzaKaNnTseyWmRhfvxV1=gWSTzgmSZx5Nm8XK=zg@mail.gmail.com>
 <20120130185150.GA6684@opensource.wolfsonmicro.com>
Date: Tue, 31 Jan 2012 21:00:16 -0800
In-Reply-To: <20120130185150.GA6684@opensource.wolfsonmicro.com> (Mark
 Brown's message of "Mon, 30 Jan 2012 18:51:50 +0000")
Message-ID: <7vfwev5esf.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: A3011A76-4C91-11E1-9DEA-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> Yes, indeed - so probably git request-pull ought to just do that when
> working with a tag (which I guess it knows it's doing because it managed
> to add the information it pulled from the tag into the pull request)
> since it'll help with old versions and avoids confusions like this.

I heard you.

I'd appreciate it if you could Bc: either myself or git@vger.kernel.org
next time you have improvement suggestions to Git.

Thanks.
