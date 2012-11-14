Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab2KNFxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:53:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2KNFxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:53:49 -0500
Date: Tue, 13 Nov 2012 21:53:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Linus <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hughd@google.com>
Subject: Re: linux-next: Tree for Nov 14
Message-Id: <20121113215345.680e1f8e.akpm@linux-foundation.org>
In-Reply-To: <20121113213742.292f3ace.akpm@linux-foundation.org>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
	<20121113213742.292f3ace.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012 21:37:42 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> It would help if the old sched/numa code wasn't in -next while you're
> away.

Now I think about it, that's going to be hard.  If I integrate against
tomorrow's -next, the mmotm patches will be against next+schednuma. 
Then you'll need to unintegrate them - effectively redo them against
mainline.

That won't be toooo hard, but there are some tricky bits.  Is there a way
I can extract a schednuma-free -next tomorrow?  That way I can do the wrangling.

This thing really has been a pain ;(  I've been uncharacteristically
patient!
