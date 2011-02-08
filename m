Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab1BHRip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:38:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab1BHRio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:38:44 -0500
Date: Tue, 8 Feb 2011 12:38:36 -0500
From: Don Zickus <dzickus@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix setup NMI_LOCAL_APIC watchdog
Message-ID: <20110208173836.GA27728@redhat.com>
References: <AANLkTikLveTej7m7UkT6thCxD_nWbEFbF6q=ayGSj2oT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikLveTej7m7UkT6thCxD_nWbEFbF6q=ayGSj2oT@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 11:07:11PM +0800, Hillf Danton wrote:
> when testing NMI watchdog, at leat for NMI_LOCAL_APIC, the default
> value of nmi_active could prevent the dog from being tested. Even
> could not, lapic_adjust_nmi_hz() could misplay its role since the
> underlying hardware is still not initialized by lapic_watchdog_init().
> 
> And for same reason the check for wd_ops could be removed in
> enable_lapic_nmi_watchdog(), in which nmi_active is also checked.
> 
> If NMI_LOCAL_APIC is enabled thru sysctl on cmdline after bootup, how
> to test stuckup?

Your patch doesn't apply to 2.6.38 any more because that code has been
removed.  We have switched to the new nmi_watchdog.  Unless you have other
concerns, I am going to drop your patch.

Cheers,
Don
