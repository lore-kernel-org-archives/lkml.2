Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0HQTjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:39:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35009 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751316Ab0HQTjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:39:14 -0400
Date: Tue, 17 Aug 2010 20:54:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Andi Kleen <andi@firstfloor.org>,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Proposal: Use hi-res clock for file timestamps
Message-ID: <20100817205441.200ab9a4@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTi=sOW0Cgci+xX6rRmz+B-is0xb8DoKD350bFJN1@mail.gmail.com>
References: <AANLkTimnyXKahtjaFeSsgcq=xMy-pP3na1jidQhZ-dt2@mail.gmail.com>
	<87aaolwar8.fsf@basil.nowhere.org>
	<20100817174134.GA23176@fieldses.org>
	<20100817182920.GD18161@basil.fritz.box>
	<20100817190447.GA28049@fieldses.org>
	<AANLkTi=w1UA5ZZDBigpxMiL7A7DnbnQhLkg62JZpC6Ri@mail.gmail.com>
	<20100817203941.729830b7@lxorguk.ukuu.org.uk>
	<AANLkTi=sOW0Cgci+xX6rRmz+B-is0xb8DoKD350bFJN1@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am having trouble seeing why this is a better idea than a simple
> mount option to obtain decent resolution timestamps.  (Not that we
> can't have both...)  Is there any objection to the mount option I am
> proposing?

I have none. I doubt I'd use it as it would be too expensive on system
performance for some of my boxes, while having an incrementing value is
cheap.

I don't see the two as conflicting - in fact the bits you need to do the
mount option are the bits you also need to do the counter version as
well. One fixes ordering at no real cost, the other adds high res
timestamps, both are useful.

Alan
