Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1AKVZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:25:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64173 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1AKVZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:25:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=sNuCwTv/f6Rl85COGTXATPd3XkQCFId7PKi4yR1/GMtfjGZoX1T9hl10qwASCKE2A1
         7xYK/KTIA9nZTikm3vJ6bl02IMsmSwBCO+WvonMR51iurwVIUghnZuXMzfn86SKj9w3U
         2arxY2bHEdtO9QZAfnAGTqVyJNaGZmMQo3bI0=
MIME-Version: 1.0
In-Reply-To: <AANLkTiknwXJF+pLJFQPqa7XPywi=boz-H+_JLk-T+Zp8@mail.gmail.com>
References: <alpine.DEB.2.00.1101091110520.5270@tiger>
	<AANLkTim0UBNG6bVgBDQsrBhVjS0FSdLbwaipBZGkTeWF@mail.gmail.com>
	<AANLkTi=pvz-ou3_DK0dUSRYCARkwM_X9x7Xpnapjw_Ke@mail.gmail.com>
	<AANLkTiknwXJF+pLJFQPqa7XPywi=boz-H+_JLk-T+Zp8@mail.gmail.com>
Date: Tue, 11 Jan 2011 13:25:17 -0800
X-Google-Sender-Auth: 3ArrpHRWs4g-41f0R4fqKwRArvA
Message-ID: <AANLkTim29V8-w23zc=akW+F3CW-BKYR=jpWRVnr3x4E0@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.38
From: Tony Luck <tony.luck@intel.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, cl@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 8:13 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> That said, "number of commits" is not a really meaningful measure
> either. I really tend to like how the ACPI tree does things, with
> separate branches for separate bugzilla entries - with nice relevant
> branch naming (bug number or description) - and then merging them. At
> that point you may well have a branch with just a single commit in it,
> but now the extra merge actually _adds_ information and the history
> looks better for it.

There are some notes on this work flow in the git sources in
Documentation/user-manual.txt in the [[maintaining-topic-branches]]
chapter.

-Tony
