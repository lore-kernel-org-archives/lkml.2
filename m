Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0DUHeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 03:34:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1600 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab0DUHem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 03:34:42 -0400
Subject: Re: [PATCH] Whitespace Coding style fixes.
From: Joe Perches <joe@perches.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4BCEA499.6000308@gmail.com>
References: <1271833331-26973-1-git-send-email-justinmattock@gmail.com>
	 <u2mb6fcc0a1004210003v5867afcfw4b112766a6951043@mail.gmail.com>
	 <4BCEA499.6000308@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 00:34:41 -0700
Message-ID: <1271835281.1730.274.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 00:09 -0700, Justin P. Mattock wrote:
> On 04/21/2010 12:03 AM, Alexey Dobriyan wrote:
> > You screw up git-blame.
> how does this patch screw it up?

Alexey just doesn't like whitespace patches.

Whitespace patches don't really "screw up" git blame.

git blame displays the current version of a file
with line-by-line commits and the date each line
was last modified.

So whitespace changes make it harder to find which patch
introduced the last logical change for a particular line.

A more interactive git blame with history backtracking
might help keep Alexey happier but who knows for sure...

