Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2LPXv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 18:51:28 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44473 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2LPXv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 18:51:26 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1212151925410.27388@tundra.namei.org>
References: <alpine.LRH.2.02.1212151925410.27388@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Dec 2012 15:51:05 -0800
X-Google-Sender-Auth: 67oo2Esi-jceIaXKUm8Z6AIzvJ0
Message-ID: <CA+55aFxxC8xpG9KQtqxRfcJzCu58Fv711bTwtKFq3HHAvRhYBA@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.8
To: James Morris <jmorris@namei.org>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 12:28 AM, James Morris <jmorris@namei.org> wrote:
> A quiet cycle for the security subsystem with just a few maintenance
> updates.

Ok, pulled. There were a few trivial conflicts (mostly due to some of
the key allocation patches having already been merged, and some of the
kuid/kgid changes due to the userns changes).

I'd like you to double-check the end result, but it *looks* fine.
Adding both EricB and DavidH to the participants since the conflicts
were generally due to intetractions with their patches.

                Linus
