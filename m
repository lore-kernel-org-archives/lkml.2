Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1KWX6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 18:58:02 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60832 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab1KWX6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 18:58:00 -0500
MIME-Version: 1.0
In-Reply-To: <1322092017-21471-1-git-send-email-ddaney.cavm@gmail.com>
References: <1322092017-21471-1-git-send-email-ddaney.cavm@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Nov 2011 15:57:37 -0800
X-Google-Sender-Auth: xUfVb8Cc_rcBAVFn98F8pSHLoZ4
Message-ID: <CA+55aFwjUVhff6jADOSvAn=t4CTVf4ZODTNm7M6vYcmG6TikPA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Stop some of the abuse of BUG() where compile time
 checks should be used.
To: David Daney <ddaney.cavm@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        David Rientjes <rientjes@google.com>, DM <dm.n9107@gmail.com>,
        David Howells <dhowells@redhat.com>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, would it possibly make sense to make the string more useful?

For example using __FILE__ and __LINE__, or possibly letting the user
of the BUILD_BUG() give a string ("Using HMASK without
CONFIG_HUGEPAGE").

Whatever. It's bikeshedding - what would probably be more important
would be to get this into linux-next so that we find out whether there
are any compile issues with it on other platforms or compiler
versions.

                  Linus
