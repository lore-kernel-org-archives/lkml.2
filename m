Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1G1CmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 22:42:22 -0400
Received: from tundra.namei.org ([65.99.196.166]:38971 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab1G1CmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 22:42:16 -0400
Date: Thu, 28 Jul 2011 12:42:13 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Security subsystem changes for 3.1
In-Reply-To: <CA+55aFzhg+W86y7TNQ6iqFEibfy+L9irxEHLd9VOy2+mTdWTSA@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1107281240330.4840@tundra.namei.org>
References: <alpine.LRH.2.00.1107281209010.4722@tundra.namei.org> <CA+55aFzhg+W86y7TNQ6iqFEibfy+L9irxEHLd9VOy2+mTdWTSA@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1665246916-47021518-1311820933=:4840"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-47021518-1311820933=:4840
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 27 Jul 2011, Linus Torvalds wrote:

> On Wed, Jul 27, 2011 at 7:13 PM, James Morris <jmorris@namei.org> wrote:
> > Please pull.
> >
> > Highlights for this window are a major upgrade to Tomoyo and a whole bunch
> > of TPM fixes.  Fairly quiet otherwise.
> 
> Argh. Please don't pre-resolve conflicts outside of your subsystem.
> 
> I *want* to see conflicts. I want to see who is stepping on whose
> toes, and where problems occur.

Ok, but this conflict was in my subsystem.

> 
> If you know it's some complicated conflict (this one really wasn't), I
> do appreciate if it people do a "I have a pre-resolved branch in xyz,
> so you can verify the end result from there, or just take it if you
> are lazy", but even that isn't really required. If it really ends up
> being too complicated for me, and no such branch exists, I'll let you
> know. It happens, although it's pretty rare.
> 
> So I took the unresolved branch instead of your merge,
> 
>                               Linus
> 

-- 
James Morris
<jmorris@namei.org>
--1665246916-47021518-1311820933=:4840--
