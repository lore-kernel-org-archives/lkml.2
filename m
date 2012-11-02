Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab2KBUkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:40:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46712 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2KBUkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:40:06 -0400
MIME-Version: 1.0
In-Reply-To: <50942E05.9040607@oracle.com>
References: <1351811167-14856-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFxxdFCiOHEz_xWx1vjMkpQzab_Mdmd2dweknayhVBx6kA@mail.gmail.com>
 <50932F6E.5060506@oracle.com> <CA+55aFy9QSZhFpEt=iEvYTHMGhd3ARwpHfZ+PghHNAEcP6Ko7g@mail.gmail.com>
 <50942E05.9040607@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Nov 2012 13:39:43 -0700
X-Google-Sender-Auth: lHD4i_6OcgHWcu0M9EZHomksoKk
Message-ID: <CA+55aFyOX5qiakpoSBELCAbc3xkcxqf_-dcaxb40Gtrp7BXenw@mail.gmail.com>
Subject: Re: [RFC] hlist: drop the node parameter from iterators
To: Sasha Levin <sasha.levin@oracle.com>
Cc: paulmck@linux.vnet.ibm.com, dipankar@in.ibm.com, mingo@kernel.org,
        hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        peter.senna@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 1:33 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> Do you want the patch on top of your git head, or on top of -next?

So the thing is, there's no way I'm going to apply this kind of patch
anywhere *near* a merge window. With something like this, it needs to
get applied a few weeks after the merge window closes (when things
have calmed down) _and_ a few weeks before the next one opens (so that
we see the results in -next, and don't scramble for the next merge
window). IOW, around the -rc4 timeframe.

It sounds like it's not quite ready yet, which means that I'm not
comfy with it this round, and we'd better do this around 3.8-rc4 or so
(ie roughly this timeframe of the next release - I'll do 3.7-rc4
either today or tomorrow).

             Linus
