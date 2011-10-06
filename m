Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274Ab1JFVIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 17:08:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41865 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab1JFVI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 17:08:29 -0400
Date: Thu, 6 Oct 2011 22:08:10 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, seiji.aguchi@hds.com,
        vgoyal@redhat.com, tony.luck@intel.com, gong.chen@intel.com,
        satoru.moriya@hds.com, avi@redhat.com
Subject: Re: [RFC][PATCH] x86, reboot:  use NMI instead of REBOOT_VECTOR to
 stop cpus
Message-ID: <20111006210810.GA30040@srcf.ucam.org>
References: <1317236148-15134-1-git-send-email-dzickus@redhat.com>
 <20111006205042.GM5795@redhat.com>
 <201110062300.24513.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110062300.24513.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It sounds reasonable to me, but it's a little outside my area of 
experience.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
