Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1G1CdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 22:33:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103Ab1G1CdR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 22:33:17 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1107281209010.4722@tundra.namei.org>
References: <alpine.LRH.2.00.1107281209010.4722@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Jul 2011 19:32:53 -0700
Message-ID: <CA+55aFzhg+W86y7TNQ6iqFEibfy+L9irxEHLd9VOy2+mTdWTSA@mail.gmail.com>
Subject: Re: [GIT] Security subsystem changes for 3.1
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 7:13 PM, James Morris <jmorris@namei.org> wrote:
> Please pull.
>
> Highlights for this window are a major upgrade to Tomoyo and a whole bunch
> of TPM fixes.  Fairly quiet otherwise.

Argh. Please don't pre-resolve conflicts outside of your subsystem.

I *want* to see conflicts. I want to see who is stepping on whose
toes, and where problems occur.

If you know it's some complicated conflict (this one really wasn't), I
do appreciate if it people do a "I have a pre-resolved branch in xyz,
so you can verify the end result from there, or just take it if you
are lazy", but even that isn't really required. If it really ends up
being too complicated for me, and no such branch exists, I'll let you
know. It happens, although it's pretty rare.

So I took the unresolved branch instead of your merge,

                              Linus
