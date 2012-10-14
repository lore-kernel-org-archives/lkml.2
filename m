Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2JNPlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:41:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60969 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab2JNPk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:40:58 -0400
Date: Sun, 14 Oct 2012 17:40:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq, powernow-k8: Remove usage of smp_processor_id()
 in preemptible code
Message-ID: <20121014154055.GB25734@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, linux-pm@vger.kernel.org
References: <20121009193844.GC7724@alberich>
 <20121010124839.GA22448@alberich>
 <20121012151841.GA4571@alberich>
 <27008283.MeT6T60WP8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <27008283.MeT6T60WP8@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 10:27:22AM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> Thanks for the patch!  I'll queue it up for v3.7 when I get back home from
> the current trip (around the -rc3 time frame I suppose).
> 
> In future please don't send patches directly to stable@vger.kernel.org.
> That doesn't make -stable pick them up anyway and confuses things.

That happens anyway if you tag the patch for stable and use git
send-email. Unless you go the extra mile and filter out the cc list,
which is tedious.

Besides, I'm pretty sure stable maintainers verify a patch is actually
upstream before applying it anyway.

-- 
Regards/Gruss,
    Boris.
