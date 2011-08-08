Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1HHGP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 02:15:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51818 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1HHGP0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 02:15:26 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFz5-Zwnzvi=7x2T+b6gpHSppUXn-h7jXmvoA_WtsnO4jQ@mail.gmail.com>
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
	<alpine.DEB.2.00.1108072155240.9480@tiger>
	<CA+55aFzdp+7+AcCFbx3dCkfqERzYvOZG3c3SUuNAw+X0MJ8iNw@mail.gmail.com>
	<alpine.DEB.2.00.1108080817050.25955@tiger>
	<CA+55aFz5-Zwnzvi=7x2T+b6gpHSppUXn-h7jXmvoA_WtsnO4jQ@mail.gmail.com>
Date: Mon, 8 Aug 2011 14:15:25 +0800
Message-ID: <CAJn8CcE2itKxq7xfjWxK31oVyF7Ge0qpd6NKpsmRs=A5fN-PNw@mail.gmail.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
From: Xiaotian Feng <xtfeng@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, Dave Jones <davej@redhat.com>,
        Christoph Lameter <cl@linux.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 2:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Aug 7, 2011 at 10:18 PM, Pekka Enberg <penberg@kernel.org> wrote:
>>
>> No, I haven't tested the patch myself but here's one in proper format in
>> case someone wants to test it.
>
> Dave? It sounded like it was reasonably easily reproducible in your
> setup? Xiaotian?

Yes, a few minutes after I start building kernel, the corruption warning
will occur.

>
> I obviously already released -rc1, but it would be nice to get this
> one behind us regardless. Or, alternatively, know that what Pekka
> found isn't the root cause of your problems..
>
>                      Linus
>
