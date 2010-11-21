Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab0KUUda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 15:33:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59636 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755531Ab0KUUd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 15:33:28 -0500
Date: Sun, 21 Nov 2010 20:31:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Greg KH <greg@kroah.com>, "Ted Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Subject: Re: Challenges with doing hardware bring up with Linux first
Message-ID: <20101121203124.1ba8212e@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTik6MQjYTCQ4wtyRpOGb94uyUTA+juvX-8UsP95J@mail.gmail.com>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
	<F46C52ED-8DB8-4347-957D-B9D84406D53F@mit.edu>
	<AANLkTinyafwe9MyXhSSe5vxEKnTUeLV0AZDWY_uXsu8f@mail.gmail.com>
	<20101121130236.GE23423@thunk.org>
	<20101121172906.GD3703@kroah.com>
	<AANLkTik6MQjYTCQ4wtyRpOGb94uyUTA+juvX-8UsP95J@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right -- which is why ideally I think it'd be nice to have an open
> permissive stack people shared. My preference would be to just pick up

Which we know in practice they won't. They'll sit on fixes (often
security fixes) and tweak and add private copies of features. In turn the
Linux one could then only keep up by adding features itself - which would
have to be GPL to stop the same abuse continuing.

It's a nice idea but the corporations exist to make money and adding
proprietary custom stack add-ons is clearly a good move on their part to
do that.

Alan
