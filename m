Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1KCAGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:06:20 -0400
Received: from ozlabs.org ([203.10.76.45]:55229 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1KCAGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:06:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PULL] virtio
In-Reply-To: <1320209564.9173.6.camel@lappy>
References: <87wrbkvh3v.fsf@rustcorp.com.au> <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy> <20111101124223.GA14060@redhat.com>  <8739e7uy87.fsf@rustcorp.com.au> <1320209564.9173.6.camel@lappy>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 03 Nov 2011 08:37:01 +1030
Message-ID: <87hb2mtbzu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Nov 2011 06:52:44 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> Since the PCI spec allows you to have the MSI-X table and the PBA in
> completely different regions pointed by two different BARs, we did so in
> kvm tools and have BAR 1 pointing to the MSI-X table, and BAR 2 pointing
> to the PBA ( - we *already* provided the second BAR and used it for
> something else).

Got it!  Thanks for the explanation.

Cheers,
Rusty.
