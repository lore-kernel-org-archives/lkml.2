Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1KAVhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:37:14 -0400
Received: from tundra.namei.org ([65.99.196.166]:57600 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab1KAVhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:37:12 -0400
Date: Wed, 2 Nov 2011 08:37:11 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v6 0/3] security: Yama LSM
In-Reply-To: <CAGXu5jJUZoKksT3AY3fF9Nt66FL+6mDbmUnYVGVChpeV=UT_2g@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1111020835080.11087@tundra.namei.org>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org> <alpine.LRH.2.00.1111020735080.11087@tundra.namei.org> <CAGXu5jJUZoKksT3AY3fF9Nt66FL+6mDbmUnYVGVChpeV=UT_2g@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011, Kees Cook wrote:

> > We probably need to flesh out criteria for inclusion in Yama and document
> > it.
> 
> What's the best way for me to help with that documentation?

Perhaps post a basic document for review.  It doesn't have to be a novel.

One thing I'd like to see is making it clear that if a feature is nacked 
by a core maintainer, Yama is not a means to bypass that nack.  That 
maintainer will need to ack it as part of Yama, too.


- James
-- 
James Morris
<jmorris@namei.org>
