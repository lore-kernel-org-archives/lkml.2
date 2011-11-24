Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab1KXKZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:25:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab1KXKZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:25:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4ECD91E4.5090504@gmail.com>
References: <4ECD91E4.5090504@gmail.com> <1322092017-21471-1-git-send-email-ddaney.cavm@gmail.com> <CA+55aFwjUVhff6jADOSvAn=t4CTVf4ZODTNm7M6vYcmG6TikPA@mail.gmail.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, DM <dm.n9107@gmail.com>,
        David Daney <david.daney@cavium.com>,
        "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>
Subject: Re: [PATCH v3 0/2] Stop some of the abuse of BUG() where compile time checks should be used.
Date: Thu, 24 Nov 2011 10:24:55 +0000
Message-ID: <20469.1322130295@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney <ddaney.cavm@gmail.com> wrote:

> We thought about doing that, but without doing some complex preprocessor fu,
> the GCC attribute ((error())) thing doesn't do what we want.
> 
> It appears that if more than a single instance of the construct is used in a
> compilation unit, the string emitted by the compiler for any of the violations
> will be the last string encountered.

Have you tried asking the gcc folks if this is likely to get fixed soon?

David
