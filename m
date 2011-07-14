Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1GNA6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:58:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab1GNA6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:58:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87hb6qwc57.fsf@tucsk.pomaz.szeredi.hu>
References: <87hb6qwc57.fsf@tucsk.pomaz.szeredi.hu> <87tyar6gv8.fsf@tucsk.pomaz.szeredi.hu> <4E0AF2BA.2040706@gmail.com> <1302756608.2854.10.camel@perseus.themaw.net> <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com> <4DA5DCB8.3040101@gmail.com> <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com> <4DA5F569.9020309@gmail.com> <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com> <24792.1302808448@redhat.com> <2477.1309342656@redhat.com> <4E1962BE.8010204@redhat.com> <1408.1310382069@redhat.com> <1310385651.18678.59.camel@twins> <CAOMqctQoO7zKojoEuYri8ZWDDMM3Ef6VRtPYzsf-02xhJ8e6jA@mail.gmail.com> <1310392232.4276.14.camel@perseus.themaw.net> <CAOMqctSDxauVLw5OisAeCaFa7DvZDgg_1YCmHaWdJZm60JDVtg@mail.gmail.com> <1310405033.4276.28.camel@perseus.themaw.net> <CAOMqctSZcAuA8r=Bdtg1hhM9xzDmDuOPn376HXuQ0Tb8xrRwzw@mail.gmail.com> <30216.1310558525@redhat.com> 
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Michal Suchanek <hramrach@centrum.cz>,
        Ian Kent <ikent@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ric Wheeler <rwheeler@redhat.com>, Alexander Viro <aviro@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Union mount and lockdep design issues
Date: Thu, 14 Jul 2011 01:57:38 +0100
Message-ID: <18169.1310605058@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Normally overlayfs would be immune to this, since lower/upper are
> different filesystem types.  But overlayfs-over-overlayfs would see the
> same lockdep warnings, right?

Yes.

David
