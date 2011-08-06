Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab1HFTcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 15:32:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756191Ab1HFTcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 15:32:11 -0400
MIME-Version: 1.0
In-Reply-To: <20110805182008.GA22314@redhat.com>
References: <20110805010038.GA18148@redhat.com> <20110805084614.GA1588@x4.trippels.de>
 <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
 <alpine.DEB.2.00.1108051131440.28580@router.home> <20110805163948.GA11113@redhat.com>
 <alpine.DEB.2.00.1108051146180.28580@router.home> <20110805165119.GA11593@redhat.com>
 <alpine.DEB.2.00.1108051158400.28580@router.home> <20110805171607.GA11703@redhat.com>
 <alpine.DEB.2.00.1108051312090.28580@router.home> <20110805182008.GA22314@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 6 Aug 2011 12:31:19 -0700
Message-ID: <CA+55aFwGSJM6g+YXfy_Oyb0OpQP5kH=OxCR-pnBk7RUshL+mXg@mail.gmail.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
To: Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anybody has any ideas on this one? I'm back home, no more diving :(,
ready to make -rc1, but I'd *prefer* to have a handle on this one.

Of course, the fact that it apparently only happens with SLUB
debugging on means that the impact is less, but on the other hand I
really like all the people who enable debug features and help us test
with those on. So..

                                      Linus
