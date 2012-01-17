Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab2AQIel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:34:41 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42535 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2AQIej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:34:39 -0500
Message-ID: <1326789274.2564.55.camel@edumazet-laptop>
Subject: Re: [PATCH] mips: remove custom BUILD_BUG()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, DM <dm.n9107@gmail.com>,
        David Howells <dhowells@redhat.com>,
        David Daney <david.daney@cavium.com>
Date: Tue, 17 Jan 2012 09:34:34 +0100
In-Reply-To: <20120117082841.GA15499@linux-mips.org>
References: <1322092017-21471-1-git-send-email-ddaney.cavm@gmail.com>
	 <1322092017-21471-2-git-send-email-ddaney.cavm@gmail.com>
	 <1326779572.2564.47.camel@edumazet-laptop>
	 <20120117082841.GA15499@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 janvier 2012 à 09:28 +0100, Ralf Baechle a écrit :

> See 63e9c4fd1c86e894e62aa3737427163d5fb01056 [MIPS: Remove temporary kludge
> from <asm/page.h>] in linux-next.
> 

Good, thanks !


