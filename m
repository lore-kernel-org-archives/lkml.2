Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab1I2QbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 12:31:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab1I2QbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 12:31:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com>
References: <CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com> <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com> <2150.1314882260@redhat.com> <CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com> <CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com> <5149.1317036720@redhat.com> <CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com> <CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com> <6324.1317308270@redhat.com> 
To: Mark Moseley <moseleymark@gmail.com>
Cc: dhowells@redhat.com,
        Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
Date: Thu, 29 Sep 2011 17:30:18 +0100
Message-ID: <12748.1317313818@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Moseley <moseleymark@gmail.com> wrote:

> >> [12999.564897] FS-Cache: Cookie 'NFS.fh' still has outstanding reads
> >
> > Hopefully the patch set I sent to you will deal with this.
> >
> > David
> 
> Not sure what you mean. Was there another patch besides the one to get
> more info in the traceback?

I emailed a set of 13 patches to you a short time before that.  Hopefully
they'll fix the outstanding-reads problem the bad-page-state problem.

David
