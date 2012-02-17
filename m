Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2BQJUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:20:40 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:45986 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2BQJUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:20:38 -0500
Date: Fri, 17 Feb 2012 10:20:24 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/s390/kernel/crash_dump.c: included
 linux/crash_dump.h twice
Message-ID: <20120217102024.1c838437@de.ibm.com>
In-Reply-To: <1329400541-31849-1-git-send-email-danny.kukawka@bisect.de>
References: <1329400541-31849-1-git-send-email-danny.kukawka@bisect.de>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12021709-4966-0000-0000-0000017C352A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 14:55:41 +0100
Danny Kukawka <danny.kukawka@bisect.de> wrote:

> arch/s390/kernel/crash_dump.c included 'linux/crash_dump.h' twice,
> remove the duplicate.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Added to the s390 tree. Thanks.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

