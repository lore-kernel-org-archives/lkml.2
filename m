Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab1F3OdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 10:33:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41255 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1F3Ocz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:32:55 -0400
MIME-Version: 1.0
X-Originating-IP: [89.105.122.66]
In-Reply-To: <20110629080827.GA975@phantom.vanrein.org>
References: <fa.fHPNPTsllvyE/7DxrKwiwgVbVww@ifi.uio.no>
	<532cc290-4b9c-4eb2-91d4-aa66c01bb3a0@glegroupsg2000goo.googlegroups.com>
	<BANLkTik3mEJGXLrf_XtssfdRypm3NxBKvkhcnUpK=YXV6ux=Ag@mail.gmail.com>
	<20110629080827.GA975@phantom.vanrein.org>
Date: Thu, 30 Jun 2011 15:32:54 +0100
X-Google-Sender-Auth: -JCF-x_0mAk7GFdXeT6jlM1VvNs
Message-ID: <BANLkTimMFCh+bgF8FaQYUbVrshxUReD_Xw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
From: Jody Belka <jody+lkml@jj79.org>
To: Rick van Rein <rick@vanrein.org>
Cc: Craig Bergstrom <craigb@google.com>, fa.linux.kernel@googlegroups.com,
        "H. Peter Anvin" <hpa@zytor.com>, Stefan Assmann <sassmann@kpanic.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        Nancy Yuen <yuenn@google.com>, Michael Ditto <mditto@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 June 2011 09:08, Rick van Rein <rick@vanrein.org> wrote:
>
> Hello Craig,
>
> > Some folks had mentioned that they're interested in details about what
> > we've learned about bad ram from our fleet of machines.  I suspect
> > that you need ACM portal access to read this,
>
> I'm happy that this didn't cause a flame, but clearly this is not the
> right response in an open environment.  ACM may have copyright on the
> *form* in which you present your knowledge, but could you please poor
> the knowledge in another form that bypasses their copyright so the
> knowledge is made available to all?

Luckily one of the authors (Bianca Schroeder) has a copy on her
university web space, free for personal/classroom use. Can be found at
http://www.cs.toronto.edu/~bianca/, search for "DRAM errors in the
wild".
