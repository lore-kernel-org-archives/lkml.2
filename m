Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1E3TxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:53:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63250 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1E3TxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=KZ4q9PMycfq1ieK5PeA2SR2gZ25HxQpBJx3wi5y46IvnM8tD91o5D1EDl9qjGZnTbw
         4QYFUCW33f++VmgBxvGy/yPBoIQ/z0Rf3mLtP8GaLwk3LynDW4wgNJuClKogr1NUm9Bb
         BAwXe0M4X6ul+eWGZturMmDNlD+SRawSl56sM=
MIME-Version: 1.0
In-Reply-To: <20110530182221.GA16214@gere.osrc.amd.com>
References: <rohityadav89@gmail.com> <1306776629-13404-1-git-send-email-rohityadav89@gmail.com>
 <11791.1306777203@turing-police.cc.vt.edu> <BANLkTim2yJkQG=2JzFwxcAUfB3HF_m52Rg@mail.gmail.com>
 <13206.1306779099@turing-police.cc.vt.edu> <20110530182221.GA16214@gere.osrc.amd.com>
From: Rohit Yadav <rohityadav89@gmail.com>
Date: Tue, 31 May 2011 01:22:54 +0530
Message-ID: <BANLkTikKjjnai0kvvdA9OdBeBhkJWT9=oQ@mail.gmail.com>
Subject: Re: [PATCH] Arch: x86: process: Fix a compilation warning.
To: Borislav Petkov <bp@amd64.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yep, all valid points. Another one would be to search whether this got
> already fixed before wasting effort:
>
> http://git.kernel.org/tip/598e887d8b01655780c81cc86a9e7820ed091580

What is the best way to search if something got fixed? There are
plenty of repositories at git.kernel.org
I'm using this one:
http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Thanks.
