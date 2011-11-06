Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab1KFX03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:26:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60379 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1KFX02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:26:28 -0500
MIME-Version: 1.0
In-Reply-To: <20111107095429.28cb33a8ec512a2bd7690dba@canb.auug.org.au>
References: <20111107095429.28cb33a8ec512a2bd7690dba@canb.auug.org.au>
Date: Sun, 6 Nov 2011 18:26:26 -0500
X-Google-Sender-Auth: -ZF8CgBj5kFcH0OOH9T15joOSHQ
Message-ID: <CAJvTdK=tcFaqmDdtW6zCaddBixVE9Ee2SGAv39fjJtbTp-iDZw@mail.gmail.com>
Subject: Re: linux-next: failing to fetch the acpi tree
From: Len Brown <lenb@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am still fetching from git://github.com/lenb/linux.git#acpi, is that correct?

Hi Stephen,

wow -- what was fast, I just nuked that branch about 30 minutes ago:-)

Please delete my github tree from your linux-next script
and start using this one:

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git next

This "next" branch will be the consolidation of what used to be
acpi-test
idle-test
tools
and whatever other power management trees I used to have for linux-next.

BTW. At this instant the new branch is empty, while I do my own testing.

thanks,
-Len
