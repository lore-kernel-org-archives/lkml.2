Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab1EIU6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:58:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838Ab1EIU6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:58:07 -0400
Date: Mon, 9 May 2011 13:57:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@google.com>
Subject: Re: [PATCH] softlockup: re-increase hung tasks check from 2 minutes
 to 8 minutes
Message-Id: <20110509135741.36320e27.akpm@linux-foundation.org>
In-Reply-To: <4DC4153E.5020304@suse.com>
References: <4DC4153E.5020304@suse.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 May 2011 11:35:26 -0400
Jeff Mahoney <jeffm@suse.com> wrote:

>  Commit e162b39a, which moved the soft lockup code around a bit,
>  accidentally reverted commit fb822db4, which extended the soft lockup
>  timeout from 2 minutes to 8 minutes.
> 
>  This patch restores it to 8 minutes.

Nit: it's conventional to refer to commits in the following manner:

e162b39a ("softlockup: decouple hung tasks check from softlockup detection")

because a commit can have a different hash in different trees.

Notnit: "softlockup: decouple hung tasks check from softlockup
detection" was merged two years ago.  Shouldn't we have a Cc:
<stable@kernel.org> in this changelog?

