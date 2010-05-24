Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab0EXTI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 15:08:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42395 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0EXTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 15:08:26 -0400
Date: Mon, 24 May 2010 20:08:04 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100524190804.GA21874@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com> <87wrvl5479.fsf@deeprootsystems.com> <20100503215028.GB18910@srcf.ucam.org> <20100524185754.GD1292@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100524185754.GD1292@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 08:57:54PM +0200, Pavel Machek wrote:

> And btw I do have wakelock-less implementation of autosleep, that only
> sleeped the machine when nothing was ready to run. It was called
> "sleepy linux". Should I dig it out?

As has been explained several times now, that's not equivalent. The 
difference is what makes this a hard problem. If a usecase is valid and 
nobody can come up with a convincing explanation of what an elegant 
solution would look like, then the ugly solution wins.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
