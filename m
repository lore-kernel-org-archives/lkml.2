Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0HTPgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:36:50 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58770 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0HTPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ngKqiacv94R0/1LfcbnL2urr8zQyMvAa7Q1JkVAPPuzUmOpQ08jffTW4pOB1LJ9iLR
         jCNdytt9p+LJg8OWhdUXDT6kfokusevtJVQxTJZqjvHb6mWkr4plwrp40LZcLXu+IiZc
         Vz8dnev+KHv7BtCTWQVFz3LVzsakH9B+vudsM=
Subject: Re: [PATCH 0/4] initramfs: remove sparse warnings
From: Namhyung Kim <namhyung@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100820120001.GR31363@ZenIV.linux.org.uk>
References: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
	 <201008191638.23248.arnd@arndb.de>
	 <20100820120001.GR31363@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 00:36:41 +0900
Message-ID: <1282318601.1626.9.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-20 (금), 13:00 +0100, Al Viro:
> No.  This code should *NOT* use the VFS guts, TYVM.  The whole fscking point
> is that this puppy is a sequence of plain vanilla syscalls, ideally run
> simply in userland thread.  We used to have a magical mystery shite in there
> and it had been a huge PITA.

So is it worth to work on removing the warnings like this patchset does?
Or else, how can I improve the code even a bit? Can you please give me a
direction?

-- 
Regards,
Namhyung Kim


