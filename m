Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1G3GGB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 02:06:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab1G3GF6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 02:05:58 -0400
MIME-Version: 1.0
In-Reply-To: <4e32f13721205e7dbe@agluck-desktop.sc.intel.com>
References: <4e32f13721205e7dbe@agluck-desktop.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Jul 2011 23:05:36 -0700
Message-ID: <CA+55aFwHDzqjsuBPAEecpxXiaBSLfDHjhrOUwPKWoG5LANq8CA@mail.gmail.com>
Subject: Re: [git pull] pstore + ia64 changes
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 10:43 AM, Luck, Tony <tony.luck@intel.com> wrote:
>
> please pull from:
>
>        git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git release
>
> This will update the files shown below.

Is there any reason why ia64 changes are in the same branch as pstore?

It seems totally illogical, and against all the normal "topic branch" rules.

       Linus
