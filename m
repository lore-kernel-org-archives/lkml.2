Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2BWA0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:26:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58483 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2BWA0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:26:04 -0500
MIME-Version: 1.0
In-Reply-To: <4F4584EB.9060605@zytor.com>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
 <4F456D8F.1080801@zytor.com> <CA+55aFw4P1qUye5YOJKSQHX+TfxbEDWMF7LPogj128b6gv2Nqg@mail.gmail.com>
 <CA+55aFziJ=Lw0KxxThwfqRPR+K0OWDorKAfkgKMGPXv5O404JA@mail.gmail.com> <4F4584EB.9060605@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 16:25:42 -0800
X-Google-Sender-Auth: uE2Fp9zP4pnA2AAIrd8vbqZVFC8
Message-ID: <CA+55aFxC6JwWsNcmkQ+DROXtWCzaq52DuX5aMJZfXMLoNCbsWg@mail.gmail.com>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 4:14 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Immediate failure, still.

Damn, I'll have to look closer at what else is missing then.

I really didn't want to back-port the whole series as-is, but that
would certainly have been easier.

                Linus
