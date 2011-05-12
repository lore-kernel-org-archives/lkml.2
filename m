Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab1ELTRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:17:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755816Ab1ELTRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:17:50 -0400
MIME-Version: 1.0
In-Reply-To: <4DCC2CFD.4010807@kdbg.org>
References: <BANLkTi=kb_m-CfrpnD8qQTVYLGaDdgy_tg@mail.gmail.com>
 <BANLkTi=YDZa+BRaG90vJsjrT9VxgySrDRQ@mail.gmail.com> <4DCC2CFD.4010807@kdbg.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 May 2011 12:17:00 -0700
Message-ID: <BANLkTimuSNHm_-tPV2EQZp6acDsei9f2Mw@mail.gmail.com>
Subject: Re: AAARGH bisection is hard (Re: [2.6.39 regression] X locks up hard
 right after logging in)
To: Johannes Sixt <j6t@kdbg.org>
Cc: Andrew Lutomirski <luto@mit.edu>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, git@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:54 AM, Johannes Sixt <j6t@kdbg.org> wrote:
>
> Except that you should git reset --hard; git bisect reset gets you out
> of bisect-mode, no?

Yeah, sorry, my bad.

                Linus
