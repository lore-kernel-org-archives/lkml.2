Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1JLKHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 06:07:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab1JLKHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 06:07:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAOH1cHkTiitknOsjnu9n7B2Ax+pSgM-EFDFJodjDnamxt3RMCA@mail.gmail.com>
References: <CAOH1cHkTiitknOsjnu9n7B2Ax+pSgM-EFDFJodjDnamxt3RMCA@mail.gmail.com> <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com> <2150.1314882260@redhat.com> <CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com> <CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com> <5149.1317036720@redhat.com> <CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com> <CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com> <6324.1317308270@redhat.com> <CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com> <12748.1317313818@redhat.com> <CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com> <CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com> <18003.1317336244@redhat.com> <CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com> <6261.1317385734@redhat.com> <CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com> <8905.1317984176@redhat.com> <CAOH1cHmpFF8!
 vT8HVU3RL95p_s9ec2RJ1+o4K2TOrWX2QJrvwog@mail.gmail.com> <1448.1318338420@redhat.com> 
To: Mark Moseley <moseleymark@gmail.com>
Cc: dhowells@redhat.com,
        Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Date: Wed, 12 Oct 2011 11:05:55 +0100
Message-ID: <9908.1318413955@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Moseley <moseleymark@gmail.com> wrote:

> > Hmmm...  An object is being added to the object list twice.  It may
> > indicate a free before an object is finished with.  Do you have slab
> > debugging turned on?
> 
> It's compiled in but not currently enabled. Should I do so? And
> anything I should be looking for in it?

This raises another question: Which of CONFIG_SLAB/SLOB/SLUB are you actually
using?

David
