Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab2DGTCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 15:02:10 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57871 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab2DGTCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 15:02:05 -0400
Date: Sat, 7 Apr 2012 20:03:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
Message-ID: <20120407200355.6be37c34@pyramind.ukuu.org.uk>
In-Reply-To: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You do not need to make dual licenses when licenses are compatible
> with each other, and in fact at times this can confuse developers / legal.

Firstly you are out of order touching the licensing tags of other vendors
code. Absolutely and utterly. So nobody should for example be touching an
Intel MODULE_LICENSE() tag without the say so of Intel legal.

Secondly there are specific reasons this was done. For one it protects us
from the FSF doing insane things - which is always useful. For the second
it avoids ambiguity about licensing and it avoid assorted problems where
'compatible' isn't really good enough.

Consider the case of

Take MIT source
Is it GPL compatible ?
	Yes
Add GPL Compatible tag
Compile
Ship user the binary (under the MIT license), lock the source away

Conside also the case of

Public domain
Put into kernel
Oh look no patent transfer clause
Sue recipient of kernel

There are good legal reasons we did it the way we did. This shouldn't be
changed without a proper legal evaluation.

Dual Foo/GPL is not the same as GPL compatible.

NAK

Alan
