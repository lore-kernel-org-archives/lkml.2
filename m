Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1F1WAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:00:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35848 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752400Ab1F1WAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:00:20 -0400
Date: Tue, 28 Jun 2011 23:02:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 03/29] gma500: Ensure the frame buffer has a linear
 virtual mapping
Message-ID: <20110628230245.4cec6958@lxorguk.ukuu.org.uk>
In-Reply-To: <20110628211859.GA23217@kroah.com>
References: <20110616160104.6039.44019.stgit@localhost.localdomain>
	<20110616160642.6039.31781.stgit@localhost.localdomain>
	<20110628211859.GA23217@kroah.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any ideas?
> 
> Is there drm changes in linux-next for this driver that I don't have?
> 
> If so, maybe we need to just start sending these patches through that tree?

Not DRM - looks like more sem-random treewide damage in -next tht has yet
again not gone via the maintainers of subsystems.

e44ba033c5654dbfda53461c9b1f7dd9bd1d198f

28f65c11f2ffb3957259dece647a24f8ad2e241b

Can you drop the bits you have merged and I'll send you a new set (which
will instead break the stuff Jiri has in his tree and he can fix it up)

Really though this sort of treewide trivial has to stop, its costing tons
of time and delays in real work. It should all be going via maintainers
of subsystems but clearly Jiri is letting stuff through that isn't
trivial but is in fact nuisance.

Alan
