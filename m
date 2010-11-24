Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0KXSNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:13:47 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47039 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab0KXSNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:13:46 -0500
References: <1290540725-2911-1-git-send-email-dzickus@redhat.com> <1290540725-2911-3-git-send-email-dzickus@redhat.com> <4CEC853B.6080508@kernel.org> <20101124140859.GC22165@redhat.com>
In-Reply-To: <20101124140859.GC22165@redhat.com>
Mime-Version: 1.0 (iPhone Mail 8B117)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <281207A1-2989-43A5-B852-F19B3A1274FB@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        LKML <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8B117)
From: Yinghai <yinghai@kernel.org>
Subject: Re: [PATCH 2/3] x86, nmi_watchdog:  remove the old nmi_watchdog
Date: Wed, 24 Nov 2010 10:12:27 -0800
To: Don Zickus <dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Nov 24, 2010, at 6:08 AM, Don Zickus <dzickus@redhat.com> wrote:

> On Tue, Nov 23, 2010 at 07:23:39PM -0800, Yinghai Lu wrote:
>>> -    {
>>> -        .procname       = "nmi_watchdog",
>>> -        .data           = &nmi_watchdog_enabled,
>>> -        .maxlen         = sizeof (int),
>>> -        .mode           = 0644,
>>> -        .proc_handler   = proc_nmi_enabled,
>>> -    },
>> 
>> wonder if you can keep nmi_watchdog in sysctl? So in run-time it could be disabled after it booted up.
> 
> Well, with the new code I have watchdog_enabled which does the same thing.
> With the nmi watchdog moving to generic code, the idea was to call it a
> hardlockup detector.  I guess I was trying to rename things to avoid using
> nmi all over the place to reflect the idea that a hardlockup might be able
> to be used by something other than an nmi.
> 
> I can probably wrap this around watchdog_enabled to preserve it I suppose.
> Let me know.

Yes that will be good

Thanks