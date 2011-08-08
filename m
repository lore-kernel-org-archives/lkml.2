Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1HHGMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 02:12:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889Ab1HHGMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 02:12:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1108080817050.25955@tiger>
References: <20110805010038.GA18148@redhat.com> <20110805084614.GA1588@x4.trippels.de>
 <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
 <alpine.DEB.2.00.1108051131440.28580@router.home> <20110805163948.GA11113@redhat.com>
 <alpine.DEB.2.00.1108051146180.28580@router.home> <20110805165119.GA11593@redhat.com>
 <alpine.DEB.2.00.1108051158400.28580@router.home> <20110805171607.GA11703@redhat.com>
 <alpine.DEB.2.00.1108051312090.28580@router.home> <20110805182008.GA22314@redhat.com>
 <CA+55aFwGSJM6g+YXfy_Oyb0OpQP5kH=OxCR-pnBk7RUshL+mXg@mail.gmail.com>
 <alpine.DEB.2.00.1108072155240.9480@tiger> <CA+55aFzdp+7+AcCFbx3dCkfqERzYvOZG3c3SUuNAw+X0MJ8iNw@mail.gmail.com>
 <alpine.DEB.2.00.1108080817050.25955@tiger>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Aug 2011 23:12:25 -0700
Message-ID: <CA+55aFz5-Zwnzvi=7x2T+b6gpHSppUXn-h7jXmvoA_WtsnO4jQ@mail.gmail.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
To: Pekka Enberg <penberg@kernel.org>
Cc: Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>, xtfeng@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 7, 2011 at 10:18 PM, Pekka Enberg <penberg@kernel.org> wrote:
>
> No, I haven't tested the patch myself but here's one in proper format in
> case someone wants to test it.

Dave? It sounded like it was reasonably easily reproducible in your
setup? Xiaotian?

I obviously already released -rc1, but it would be nice to get this
one behind us regardless. Or, alternatively, know that what Pekka
found isn't the root cause of your problems..

                      Linus
