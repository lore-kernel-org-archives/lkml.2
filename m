Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab1EUXnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 19:43:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757263Ab1EUXnj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 19:43:39 -0400
MIME-Version: 1.0
In-Reply-To: <m11uzrvd26.fsf@fess.ebiederm.org>
References: <m11uzrvd26.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 May 2011 16:42:46 -0700
Message-ID: <BANLkTim4q5dK6nOb=pVKbk1c8b-Nh_hBfA@mail.gmail.com>
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Linux Containers <containers@lists.osdl.org>,
        netdev@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 4:39 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> In a hopeless quest to avoid conflicts when merging a new system call
> and wiring it up I have pulled in bits of net-next and the parisc tree.
> You have already pulled the net-next bits.  The parisc bits in my tree
> are:

Ok, this just means that I won't pull from you.

It's that simple. We don't do this. Ever.

Why the hell did you even worry about wiring up parisc system calls?
That's not your job.

                              Linus
