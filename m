Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2GWUqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:46:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50209 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab2GWUqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:46:17 -0400
Date: Mon, 23 Jul 2012 21:46:13 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch should not complain about 'Suggested-by:'
Message-ID: <20120723204613.GD2491@dm>
References: <CA+8MBbLOi=GEkewV9RR40exw4KMP85LC8J3uNLQZQcKEhMWDCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbLOi=GEkewV9RR40exw4KMP85LC8J3uNLQZQcKEhMWDCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 10:26:29AM -0700, Tony Luck wrote:
> checkpatch just gave me:
> 
>    WARNING: Non-standard signature: Suggested-by:

Seems reasonable indeed.

> There are over 500 instances of 'Suggested-by:', and it seems
> to have some value in tracking history and awarding credit
> where it is due.
> 
> "Reported-and-tested-by:" is also in regular use, but not

I really wish we didn't have this habit ...
Reported-fixed-tested-reviewed-and-signed-off-by: isn't easy to deal
with :/.

> in the list of "standard" signatures.

Will poke.

Cheers.

-apw
