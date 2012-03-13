Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030315Ab2CMJxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:53:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57349 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965119Ab2CMJw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:52:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 18/35] Create asm-generic/barrier.h [ver #2]
Date: Tue, 13 Mar 2012 09:10:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233907.13888.85219.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233907.13888.85219.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203130910.34070.arnd@arndb.de>
X-Provags-ID: V02:K0:mrKsyz77EQCASS8zY6hKXevR+PSLAjvXcJEusH6TwmQ
 IhKMNy2za7nCTsBJaNmZeBw1fcK642UIXjDP2tR4w+jUlsouro
 BsZpEYGpQ0HtniRbVahnhURW0KIZU37x2rGPl0D+Kj3EBn3ghL
 Zn0GTWEZeRBN5HIPiEgz4YUxBvMFAjPkaU8zVhDBnwCdg0XKxb
 eKq9iAf0NHmxrnQJ6TVrH5sXTwVGOAgTpArdi5+maRAPhdX1+O
 txU8SiKvZ6wgbuAGVpH1yLEovY+RvGn//P9vUL85mK3ugSi0fm
 wPDzMQJxixBNhnAO9NB+AzEzwJTf8K00PsQpdrWimnWxWdY/jd
 FYn1nAIziGhVTgclFklc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2012, David Howells wrote:
> Create asm-generic/barrier.h and move the barrier definitions from
> asm-generic/system.h to it.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

