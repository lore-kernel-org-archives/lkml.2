Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1GAUeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 16:34:15 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36763 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab1GAUeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 16:34:14 -0400
Message-ID: <4E0E2F43.8040202@kernel.dk>
Date: Fri, 01 Jul 2011 22:34:11 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Johannes Stezenbach <js@sig21.net>, Kevin Wolf <kwolf@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH resend] compat_ioctl: fix warning caused by qemu
References: <20110701093336.GA9582@sig21.net> <201107011646.28918.arnd@arndb.de>
In-Reply-To: <201107011646.28918.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-01 16:46, Arnd Bergmann wrote:
> Yes, that should be fine, unless Jens would like to see a different
> solution for the struct definitions, e.g. moving all of the floppy
> compat ioctl numbers to fd.h. I'm fine with it either way.

Looks OK to me, I've queued it up for 3.1 with your ack. Thanks
Johannes.

-- 
Jens Axboe

