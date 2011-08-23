Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab1HWVSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:18:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab1HWVSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:18:37 -0400
Date: Tue, 23 Aug 2011 14:18:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        cpufreq@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 0/3 RFC] Fix /proc/stat idle/iowait statistics for
 tickless kernel
Message-Id: <20110823141820.178b27c9.akpm@linux-foundation.org>
In-Reply-To: <20110817115925.GB7482@tiehlicka.suse.cz>
References: <20110802170249.GA23698@tiehlicka.suse.cz>
	<cover.1312544541.git.mhocko@suse.cz>
	<20110817115925.GB7482@tiehlicka.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011 13:59:25 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> Nobody interested or it just slipped through?

I was asleep on a beach at the time, am catching up now.

The patchset is a bit confusing, with an afterthough followup patch. 
Please redo it all and send a v2 series?

Then I'll queue it up and will periodically harrass Thomas with it, so
there's no point in hiding ;)
