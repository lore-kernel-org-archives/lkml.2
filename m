Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2BGTib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:38:31 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57044 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2BGTi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:38:29 -0500
MIME-Version: 1.0
In-Reply-To: <20120207074905.29797.60353.stgit@zurg>
References: <20120207074905.29797.60353.stgit@zurg>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 Feb 2012 11:38:09 -0800
X-Google-Sender-Auth: R3OmD70Sj-yh1vWSv_O-BePcvhM
Message-ID: <CA+55aFy3NZ2sWX0CNVd9FnPSx0mUKSe0XzDWpDsNfU21p6ebHQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] radix-tree: iterating general cleanup
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 11:54 PM, Konstantin Khlebnikov
<khlebnikov@openvz.org> wrote:
> This patchset implements common radix-tree iteration routine and
> reworks page-cache lookup functions with using it.

So what's the advantage? Both the line counts and the bloat-o-meter
seems to imply this is all just bad.

I assume there is some upside to it, but you really don't make that
obvious, so why should anybody ever waste even a second of time
looking at this?

                  Linus
