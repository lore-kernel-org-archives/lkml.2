Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1JSVYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:24:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39866 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1JSVYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:24:09 -0400
Date: Wed, 19 Oct 2011 23:24:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Please include const-sections into linux-next
Message-ID: <20111019212403.GL15908@one.firstfloor.org>
References: <1319039663.3034.18.camel@dabdike.int.hansenpartnership.com> <20111019161537.GH15908@one.firstfloor.org> <1319041281.3034.25.camel@dabdike.int.hansenpartnership.com> <20111019163351.GJ15908@one.firstfloor.org> <1319050557.3034.46.camel@dabdike.int.hansenpartnership.com> <20111019190517.GK15908@one.firstfloor.org> <1319054693.3034.49.camel@dabdike.int.hansenpartnership.com> <1319054816.3034.50.camel@dabdike.int.hansenpartnership.com> <3ede57fd7fb0eff1aebed4ed9cb08301.squirrel@www.firstfloor.org> <1319055260.3034.51.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319055260.3034.51.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, no, sorry ... its a false positive -fno-writeable-strings

Ok the fealnx object wasn't actually a string.

> actually produces an error which was lost in all the debug output (it's
> at the top) so it wasn't working; I only thought it was.

What's the error?

-Andi
