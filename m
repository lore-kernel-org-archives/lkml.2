Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab0E3JUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 05:20:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60841 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab0E3JUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 05:20:10 -0400
To: Len Brown <lenb@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] intel_idle: create a native cpuidle driver for select intel processors
From: Andi Kleen <andi@firstfloor.org>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
	<198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
	<20100526204426.fd2be7e0.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1005272354100.24823@localhost.localdomain>
Date: Sun, 30 May 2010 11:20:02 +0200
In-Reply-To: <alpine.LFD.2.00.1005272354100.24823@localhost.localdomain> (Len Brown's message of "Thu\, 27 May 2010 23\:57\:42 -0400 \(EDT\)")
Message-ID: <87zkzhzqyl.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

>> ... What happens when an additional CPU is brought online? 
>> It melts?  ;)
>
> With the current driver, processors hot-added after modprobe
> will use C1 only, and not use deeper C-states.

I agree with Andrew that it will likely not be a lot of 
effort to restructure the driver to handle cpu hotplug
properly, and it's better done from the beginning.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
