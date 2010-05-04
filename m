Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab0EDP2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:28:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60095 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab0EDP2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 11:28:47 -0400
Date: Tue, 4 May 2010 16:28:27 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100504152827.GB2184@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com> <87wrvl5479.fsf@deeprootsystems.com> <20100503180741.GB2098@rakim.wolfsonmicro.main> <201005032318.35383.rjw@sisk.pl> <87sk68r1zh.fsf@deeprootsystems.com> <20100504004338.GA22678@srcf.ucam.org> <878w7zog3e.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878w7zog3e.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 08:13:09AM -0700, Kevin Hilman wrote:

> So basically, on ACPI systems, runtime PM doesn't get you any power
> savings for most devices.  

I'd say it does for most devices, but the power savings may not be as 
great as they would be with fine-grained control over power rails.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
