Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345Ab2CMJwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:52:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63194 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759883Ab2CMJwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:52:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 20/35] Split the switch_to() wrapper out of asm-generic/system.h [ver #2]
Date: Tue, 13 Mar 2012 09:11:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk> <20120312233926.13888.93973.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233926.13888.93973.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203130911.30478.arnd@arndb.de>
X-Provags-ID: V02:K0:fRDBLL8wnHxzgHvEDJTfAzgulO04wJ1gbNCRhupj5vw
 TKoFzrRJduOKOXx8D1V3NUC3Q23xpnnoMkFY10HkKTMyd0g9SD
 aIPJOiQoho1iTu1dci9GtUyiK4l9QCWBKloZX9sYzZ0uq7K3HN
 em85Z0xAAY92F1dCazLR6wUuOH5WPI6iA3zZEhAEfAcXAOPKbc
 3eOKZLHSxMDYTU5IldYPTbIO6v+RuUPY0IEH0lGQi8NskUgXmc
 9IYBZSiaUzXd+cvww4KASYw9eYtxZT4dGo3Xn73UpvRveOY1u3
 4oN9T8bUfRYC41BiVJRXVuCJsOMnUZQu3xuckIc86rJfVHnO3G
 joqD9ori5qpP54mJS19o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2012, David Howells wrote:
> Split the switch_to() wrapper out of asm-generic/system.h into its own
> asm-generic/system.h as part of the asm/system.h disintegration.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

