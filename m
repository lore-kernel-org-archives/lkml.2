Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab1KVRNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:13:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57984 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab1KVRNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:13:34 -0500
MIME-Version: 1.0
In-Reply-To: <4ECB6080.7050407@gmail.com>
References: <1321925466-11280-1-git-send-email-ddaney.cavm@gmail.com> <4ECB6080.7050407@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Nov 2011 09:13:13 -0800
X-Google-Sender-Auth: 7zzx5xakl1A4_jsAECrT9bIFvQw
Message-ID: <CA+55aFw-yu0-RXB9wK=qxCnToNBKAZc4jThDLumc+bEOdxBVow@mail.gmail.com>
Subject: Re: [PATCH 0/2] Stop some of the abuse of BUG() where compile time
 checks should be used.
To: DM <dm.n9107@gmail.com>
Cc: David Daney <ddaney.cavm@gmail.com>, ralf@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 12:42 AM, DM <dm.n9107@gmail.com> wrote:
>
> Perhaps BUILD_BUG() is a more consistent name for this?
>
> We would then have BUG() and BUG_ON(x) for run-time vs BUILD_BUG() and BUILD_BUG_ON(x) for compile-time.

Yeah, that probably would be nicer naming. The "BUILD_BUG_ON_USED()"
is kind of about the implementation, not the intention of the thing.

                  Linus
