Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527Ab2C3KFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:05:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55913 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab2C3KFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:05:33 -0400
Message-ID: <4F758569.9080608@kernel.org>
Date: Fri, 30 Mar 2012 06:05:29 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, mjg@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] ACPI: Do cpufreq clamping for throttling per package
 v2
References: <1328545032-21373-1-git-send-email-andi@firstfloor.org> <1328545032-21373-5-git-send-email-andi@firstfloor.org>
In-Reply-To: <1328545032-21373-5-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,
Can you re-base this on top of my release tree?

Your fix is important, but conflicted with mjg's
more invasive percentage -> frequency change.

I opted to take mjg's patch 1st b/c I think that
your fix is important enough to integrate any time
in the release cycle - so it can go on top.

thanks,
-Len Brown, Intel Open Source Technology Center

