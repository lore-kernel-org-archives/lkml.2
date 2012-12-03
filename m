Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab2LCXkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:40:31 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41754 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab2LCXk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:40:28 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyAvpCKPWV9Mh34aV6Q4DRjATQky939vYaPBfx6+65Nxw@mail.gmail.com>
References: <CA+55aFyFLG+SxRq2=wY=8tyuQzQSHkKxonXwMmCOs=CWyOo=Mg@mail.gmail.com>
 <874nk2u69u.fsf@silenus.orebokech.com> <CA+55aFxO+nOM--EJmrT+_54jF8AL2YZ7GhbwCT2cg2qxM2Md+A@mail.gmail.com>
 <CA+8MBbJGy7xQFqi1VXPuPNHJnoZUcxjWDkmyRKeajXGAA_Q+GA@mail.gmail.com> <CA+55aFyAvpCKPWV9Mh34aV6Q4DRjATQky939vYaPBfx6+65Nxw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Dec 2012 15:40:06 -0800
X-Google-Sender-Auth: jRR_NB5hDrDKeEO2RP9ufstY_FU
Message-ID: <CA+55aFxrf=wx=fbvCRbFxt_=C4ne1-j3T=5JeLYzUG3SmpaECQ@mail.gmail.com>
Subject: Re: Linux 3.7-rc8
To: Tony Luck <tony.luck@intel.com>
Cc: Romain Francoise <romain@orebokech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 3:07 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I guess I need to try harder. I'm guessing that there's a 4kB
> filesystem there, and the block device size isn't 4kB-aligned or
> something.

Yup, I can reproduce it with that.

I'll shut the printk up some way. In the meantime, you can ignore it.

             Linus
