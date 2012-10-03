Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab2JCWlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:41:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56483 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab2JCWlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:41:22 -0400
MIME-Version: 1.0
In-Reply-To: <506CBAFC.8010908@zankel.net>
References: <506CBAFC.8010908@zankel.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Oct 2012 15:41:00 -0700
X-Google-Sender-Auth: NqWVOL5belKCUsRjf1ZLqwi9DSg
Message-ID: <CA+55aFyva3aWXBOBwERPJMyX+2LqydYs4Bq4ZBUPXZFMtPqZOg@mail.gmail.com>
Subject: Re: [GIT PULL] xtensa patchset for 3.7
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 3:23 PM, Chris Zankel <chris@zankel.net> wrote:
>
> Please pull the changes for the Xtensa architecture for v3.7.

Closer, but no cigar.

> The following changes since commit a0d271cbfed1dd50278c6b06bead3d00ba0a88f9:
>
>   Linux 3.6 (2012-09-30 16:47:46 -0700)
>
> are available in the git repository at:
>
>   git@github.com:czankel/xtensa-linux tags/xtensa-next-20121003

That should be

   git://github.com/czankel/xtensa-linux tags/xtensa-next-20121003

which is the public git address of that server.

However, you now do have a signed tag, but the key you have used for
it is not available on any of the regular keyservers. Neither
pgp.mit.edu nor keys.gnupg.net know about that key A1F191F0, which I
assume also means that it's not actually signed by anybody else
either.

I see that you're based in St Petersburg, is there anybody around you
can get your key signed with?

                    Linus
