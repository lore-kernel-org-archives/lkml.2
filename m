Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab2BVXQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 18:16:18 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37604 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2BVXQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 18:16:16 -0500
MIME-Version: 1.0
In-Reply-To: <4F456D8F.1080801@zytor.com>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org> <4F456D8F.1080801@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 15:15:55 -0800
X-Google-Sender-Auth: HrtgkI98iTdpeVai8ZVou5L3uHw
Message-ID: <CA+55aFw4P1qUye5YOJKSQHX+TfxbEDWMF7LPogj128b6gv2Nqg@mail.gmail.com>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 2:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Okay, this patchset does *NOT* work.  It fails immediately on my system.
>  I hadn't ever seen it fail so fast.

Ok, I probably missed something when I skipped the patches that
weren't appropriate for backporting (like the whole FPU state preload
removal and rewriting).

Back to the drawing board.

             Linus
