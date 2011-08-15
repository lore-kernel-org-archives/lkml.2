Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1HOOXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:23:40 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58462 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437Ab1HOOXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:23:39 -0400
X-Sasl-enc: /Khi8dFqyGu9xID2ew265H2ybf1ZAk0uaY58ZepitzeB 1313418218
Date: Mon, 15 Aug 2011 07:18:55 -0700
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] Future of the -longterm kernel releases
 (i.e. how we pick them).
Message-ID: <20110815141855.GB11358@kroah.com>
References: <20110815041524.GA7578@kroah.com>
 <20110815073309.GB18367@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815073309.GB18367@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 09:33:09AM +0200, Willy Tarreau wrote:
> You're interested in the 4th category above and I'm in the 5th. So
> in the end, I think that your proposal fits your expected target
> perfectly well, and that if I want it to fit mine, I'll just have
> to extend it myself as we've done till now. So that sounds good !

Wonderful, thanks for confirming that this would work out for you, and
that you will be willing to take on .32 in 6+ months when I am planning
on dropping it.

Keep up the great work,

greg k-h
