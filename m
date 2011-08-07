Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1HGNP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 09:15:28 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:49508 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab1HGNP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 09:15:26 -0400
Subject: Re: list corruption in the last few days. (block ? crypto ?)
From: Pekka Enberg <penberg@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <CA+55aFwGSJM6g+YXfy_Oyb0OpQP5kH=OxCR-pnBk7RUshL+mXg@mail.gmail.com>
References: <20110805010038.GA18148@redhat.com>
	 <20110805084614.GA1588@x4.trippels.de>
	 <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
	 <alpine.DEB.2.00.1108051131440.28580@router.home>
	 <20110805163948.GA11113@redhat.com>
	 <alpine.DEB.2.00.1108051146180.28580@router.home>
	 <20110805165119.GA11593@redhat.com>
	 <alpine.DEB.2.00.1108051158400.28580@router.home>
	 <20110805171607.GA11703@redhat.com>
	 <alpine.DEB.2.00.1108051312090.28580@router.home>
	 <20110805182008.GA22314@redhat.com>
	 <CA+55aFwGSJM6g+YXfy_Oyb0OpQP5kH=OxCR-pnBk7RUshL+mXg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sun, 07 Aug 2011 16:15:24 +0300
Message-ID: <1312722924.12515.13.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-06 at 12:31 -0700, Linus Torvalds wrote:
> Anybody has any ideas on this one? I'm back home, no more diving :(,
> ready to make -rc1, but I'd *prefer* to have a handle on this one.
> 
> Of course, the fact that it apparently only happens with SLUB
> debugging on means that the impact is less, but on the other hand I
> really like all the people who enable debug features and help us test
> with those on. So..

Christoph? Do we know if the problem is with partial or full list?

			Pekka

