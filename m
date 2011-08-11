Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1HKOR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:17:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37506 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1HKORZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:17:25 -0400
Date: Thu, 11 Aug 2011 15:16:30 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Ali Gholami Rudi <ali@rudi.ir>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>,
        Michel Alexandre Salim <salimma@fedoraproject.org>,
        intel-gfx@lists.freedesktop.org, Ali Gholami Rudi <aliqrudi@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: missing acpi backlight bisected to 9661e92c10
Message-ID: <20110811141630.GA24704@srcf.ucam.org>
References: <yunliv38ugd.fsf@aiko.keithp.com>
 <20110808213140.GA32504@srcf.ucam.org>
 <yunfwlb8qy4.fsf@aiko.keithp.com>
 <4E428421.1000605@fedoraproject.org>
 <yunipq5gvxd.fsf@aiko.keithp.com>
 <20110810191700.81c3a7ee.akpm@linux-foundation.org>
 <20112108083014@lilem.mirepesht>
 <20112108160718@lilem.mirepesht>
 <20110811123929.GA22409@srcf.ucam.org>
 <20112108181410@lilem.mirepesht>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20112108181410@lilem.mirepesht>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, that all looks fine. And I also can't see any way that this commit
could cause the backlight not to appear - all it does is set the parent 
if it's present. There's no new path that could cause it to return 
early. Does reverting this patch really make things work?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
