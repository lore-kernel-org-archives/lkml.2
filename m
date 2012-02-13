Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab2BMWn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:43:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab2BMWn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:43:28 -0500
Date: Mon, 13 Feb 2012 17:43:17 -0500
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mjg@redhat.com" <mjg@redhat.com>,
        "levinsasha928@gmail.com" <levinsasha928@gmail.com>
Subject: Re: [PATCH 2/2] x86, reschedule: check to see if system is shutting
 down
Message-ID: <20120213224317.GS9751@redhat.com>
References: <1329164860-668-1-git-send-email-dzickus@redhat.com>
 <1329164860-668-3-git-send-email-dzickus@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2DAC7A8FC3@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2DAC7A8FC3@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 04:22:21PM -0500, Seiji Aguchi wrote:
> 
> >+		WARN_ON(atomic_read(&stopping_cpu) == -1)
> 
> WARN_ON(atomic_read(&stopping_cpu) == -1); ?

Ugh, I really need to focus on some stuff at work before I send more crap
to the list.  Sorry about that.

Cheers,
Don
