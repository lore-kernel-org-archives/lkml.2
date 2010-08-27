Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab0H0O2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 10:28:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0H0O2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 10:28:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [RFC PATCH 03/43] ptrace: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 16:28:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com> <1282902149-12991-4-git-send-email-namhyung@gmail.com>
In-Reply-To: <1282902149-12991-4-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008271628.40023.arnd@arndb.de>
X-Provags-ID: V02:K0:7fBsAN31JlR1z1P7M93H9z7C0RclLmtRkBbEcVYVEx6
 OkMlItjLL+om1BYF87ccKESIZPjbyWL+SfRj5Q8JitCEyq4rrG
 02usUwM9fSnRfb6SZueqnfLV/gGnXDL5V/LhZjWX/46RiP4vZ4
 Uc+9aX/6Fb1mQfDK6zEU2wJm23zCZZy7Dvhr6pLGU7RL8F2j4a
 E3sKJjMREK8S7xsgjRedA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 August 2010, Namhyung Kim wrote:
> change type of @addr and @data into unsigned long.
> 
> NOTE: This patch might break build if applied alone so should be used with
> your arch counterpart.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Would it be possible to rearrange your patches so that you don't break
anything in the middle? I think merging all the trivial 'change signature'
patches into one would also make reviewing easier. Nobody in their
right mind is looking through a full series of 43 patches, especially
if they do not make sense on their own, but one patch that changes a
function signature tree-wide would be looked at by many people and can
be applied standalone.

It does make sense to keep the 'foo: clean up arch_ptrace' patches
separate though, since they are also useful on their own and need
real review by the arch maintainers.

	Arnd
