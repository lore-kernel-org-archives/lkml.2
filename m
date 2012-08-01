Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2HARbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:31:07 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41498 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2HARbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:31:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120801151318.GH6481@ZenIV.linux.org.uk>
References: <20120801151318.GH6481@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Aug 2012 10:30:41 -0700
X-Google-Sender-Auth: EWnwguDqM78pK-bR81YqsP8vNfA
Message-ID: <CA+55aFwuzzNTMCu97oroCqpsA7qk7E7iFTrzOR=n4yMmW1TqdQ@mail.gmail.com>
Subject: Re: the second vfs pile - rebase or no rebase?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 8:13 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         Alternatively, I can rebase the damn thing; up to you.

Oh, no. Those conflicts were trivial - I appreciate your description
of them, but they were simple enough that you didn't even have to
mention them. I'd *much* rather handle a few conflicts than have the
rebase dance with the problems that entails.

                Linus
