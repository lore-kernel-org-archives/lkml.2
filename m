Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab1L0OZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:25:56 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62225 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab1L0OZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:25:53 -0500
Date: Tue, 27 Dec 2011 15:25:44 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: heiko.carstens@de.ibm.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] debugfs: add missing #ifdef HAS_IOMEM
Message-ID: <20111227142544.GA30402@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <1324994908-4288-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1324994908-4288-1-git-send-email-heiko.carstens@de.ibm.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "debugfs: add tools to printk 32-bit registers" adds new functions
> which rely on IOMEM functionality which is not present on all
> architectures and therefore result in compile errors:

Ok, my fault. I was thinking everybody has it.

Acked-by: Alessandro Rubini <rubini@gnudd.com>

(on the other hand, maybe the header should have it as well? I hate
ifdef so I'd better avoid it, but I don't know what the policy is in
this case: compile-error for implicit declaration or link error for
missing symbol?  -- maybe a comment in the header is suitable?).

/alessandro
