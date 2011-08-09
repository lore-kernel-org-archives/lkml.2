Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1HIPpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:45:53 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:55983 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1HIPpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:45:51 -0400
Date: Tue, 9 Aug 2011 17:45:24 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [patch 1/1] [PATCH] include storage keys in hibernation image.
Message-ID: <20110809174524.45cd496d@mschwide>
In-Reply-To: <201107290001.14465.rjw@sisk.pl>
References: <20110608074523.211912903@de.ibm.com>
	<20110608074648.287491002@de.ibm.com>
	<201107290001.14465.rjw@sisk.pl>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011 00:01:14 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Sorry for the extreme delay.

No big deal, I have been busy with other things anyway.
 
> Having reconsidered things I think the code under the #ifdef above
> should really go to arch/s390.

Ok, that is reasonable.
 
> Now, for the purpose of exporting the headers I'd introduce
> CONFIG_ARCH_SAVE_PAGE_KEYS and make S390 do
> 
> select ARCH_SAVE_PAGE_KEYS if HIBERNATION
> 
> and I'd put a #ifdef depending on that into include/linux/suspend.h.
> 
> Apart from this, I have only one complaint, which is that the kerneldoc
> comments should follow the standard (the other comments in snapshot.c don't,
> but that's a matter for a separate patch).

Sounds good. I will come up with new patches for this and resend them
for review. Might be one or two weeks though, currently conferencing in
Orlando..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

