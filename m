Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab1KWRMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:12:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41401 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446Ab1KWRMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:12:36 -0500
Date: Wed, 23 Nov 2011 17:12:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: NamJae Jeon <linkinjeon@gmail.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>, LKML <linux-kernel@vger.kernel.org>,
        Unix Support <unix-support@ucs.cam.ac.uk>,
        Steve French <smfrench@gmail.com>, <akpm@linux-foundation.org>,
        Anton Altaparmakov <aia21@cam.ac.uk>, <ashishsangwan2@gmail.com>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Message-ID: <20111123171245.3e3f18a7@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.1111231131100.2111-100000@iolanthe.rowland.org>
References: <CAKYAXd965Md2D4mnDbROoNcKZPQs2dERh8y7aDHtoJ+FJcK1QQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1111231131100.2111-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 11:31:47 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 23 Nov 2011, NamJae Jeon wrote:
> 
> > Hi. Alan.
> > Would you know why there is no upper/lower case table in nls utf8 ?
> > And Currently Surrogate pair is not supported also in nls utf8. Is
> > there the reason ?
> 
> I don't know.

For one case translations are locale specific and very very complicated.
