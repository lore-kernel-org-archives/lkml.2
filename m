Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab1JYMDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 08:03:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48468 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab1JYMDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 08:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <20111025115634.GA12128@suse.de>
References: <20111025.063206.2273357152859701628.davem@davemloft.net>
 <CA+55aFw1GVvszqoC_f0RAvG5t1xj0CSYLhLU=y0gQ+_54Gsomw@mail.gmail.com> <20111025115634.GA12128@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Oct 2011 14:03:09 +0200
X-Google-Sender-Auth: 2sCfC_hoPcHO91qD3xD7y6En2DM
Message-ID: <CA+55aFzYW_Pku3ESH8HHHkGMu+G9UZPUSLajZy=edEnQ+vycNg@mail.gmail.com>
Subject: Re: [GIT] Networking
To: Greg KH <gregkh@suse.de>
Cc: David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mikulas Patocka <mpatocka@redhat.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 1:56 PM, Greg KH <gregkh@suse.de> wrote:
>
> The "crazy" tool was using 'git am'.  The problem was that I missed the
> fact that the first line of the patch sent to me duplicated the subject
> line.  It's a really common problem when people generate patches and
> send them off by email, I just forgot to edit the patches from Mikulas
> to remove them, my fault, sorry.

Ok, please (a) check these things before applying patches, and (b)
COMPLAIN TO EVERY SOURCE THAT SENDS YOU CRAP.

The push-back so that it doesn't happen again is important.

In other words: Mikulas - whatever tool you're using, stop using it,
or start using it correctly. Duplicating the header line in the body
of the email is crap and wrong. If you want to duplicate it in the
email, add the "Subject:" prefix to it (same goes for "Date:" and
particularly "From:" - those fields are actually destroyed by
forwarding the patches over email - unlike the subject line)

             Linus
