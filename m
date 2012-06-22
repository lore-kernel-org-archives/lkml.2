Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab2FVSVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:21:21 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40638 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2FVSVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:21:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120622121523.4DF5911F873@bugzilla.kernel.org>
References: <bug-41622-5873@https.bugzilla.kernel.org/> <20120622121523.4DF5911F873@bugzilla.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Jun 2012 11:20:57 -0700
X-Google-Sender-Auth: Nfmv5Mz_Z6-IF0TV6tUyrYa_CXM
Message-ID: <CA+55aFxKDZaCq-GP2LJpLnDKc=Zd1pmnr8Rq7bBXH9eGuyiyew@mail.gmail.com>
Subject: Re: [Bug 41622] [REGRESSION][BISECTED] Notebook crashes upon
 detecting the PCI subsystem with kernels >= 2.6.24-rc7
To: bugzilla-daemon@bugzilla.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 5:15 AM,  <bugzilla-daemon@bugzilla.kernel.org> wrote:
>
> If, on the other hand, I apply the patch mentioned in comment #17 of this bug
> report, then everything boots and works OK (for suitable values of "OK).

Gaah. These emails always happen at the most inconvenient time.

Maybe we should just try that patch in

   https://bugzilla.kernel.org/show_bug.cgi?id=41622#c17

but it really needs to happen early in a merge window. We didn't do
that for 3.2, maybe we can do it for 3.6?

Bjorn, what do you think? Sizing up transparent bridges really is a
bit unnecessary.

Although I really don't see what the difference there is any more.
Yinghai noticed that the prefetchability of the cardbus bridge
changed, but the commit that changed that apparently made no
difference. What other changes does the transparent bridge sizing
cause?

                        Linus
