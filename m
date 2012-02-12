Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab2BLRK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 12:10:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab2BLRKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 12:10:55 -0500
From: Thomas Renninger <trenn@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 4/5] intel_idle: Revert change of auto_demotion_flags for Nehalem
Date: Sun, 12 Feb 2012 18:10:50 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.10-0.4-desktop; KDE/4.4.4; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org
References: <1329000256.325.48.camel@deadeye> <1329000910.325.55.camel@deadeye>
In-Reply-To: <1329000910.325.55.camel@deadeye>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202121810.51144.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 February 2012 23:55:10 Ben Hutchings wrote:
> Commit b66b8b9a4a79087dde1b358a016e5c8739ccf186 ('intel-idle: convert
> to x86_cpu_id auto probing') added a distinction between Nehalem and
> Westemere processors and changed auto_demotion_flags for the former to
> 0.  This was not explained in the commit message, so change it back.

Yep, it looks like the change slipped in unintentionally.

   Thomas
