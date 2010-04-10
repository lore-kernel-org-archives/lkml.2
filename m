Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab0DJNma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 09:42:30 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40808 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0DJNm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 09:42:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Djl9lHV+OTsQD8Nm/wH9i1SBJ0jmKiNNXDYZPykw5R5CXfmouK61X3rBaY5uI6B8WG
         zAWLk6dLBuIzFI8+XQKtasdGIZ2YqlpGW48ih2FHrgUwBXHt5cCUupAga8L+eS9TdVFx
         wJpt2m8zAZp6ghlmKhofFdhJqMELuJHYvjS+4=
Date: Sat, 10 Apr 2010 15:42:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux Next <linux-next@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: A few tree inclusion update requests
Message-ID: <20100410134221.GC5204@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I have some requests for you about tree inclusions for linux-next.

My reiserfs/kill-bkl branch had no updates for a next release
for some time now. You can safely remove it from -next. If
I get updates for it later, I'll tell you. But for now it's
only here to host fixes for the current release.

Also I have two new branches aimed for .35

Could you please integrate the two following?

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/core

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/procfs

Thanks a lot!

