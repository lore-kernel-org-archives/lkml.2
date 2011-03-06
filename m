Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1CFThy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 14:37:54 -0500
Received: from mail.lang.hm ([64.81.33.126]:54844 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab1CFThx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 14:37:53 -0500
Date: Sun, 6 Mar 2011 11:36:24 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Vasiliy Kulikov <segoon@openwall.com>
cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] power: disable hibernation if module loading is
 disabled
In-Reply-To: <1299255084-4390-1-git-send-email-segoon@openwall.com>
Message-ID: <alpine.DEB.2.00.1103061134520.9066@asgard.lang.hm>
References: <1299255084-4390-1-git-send-email-segoon@openwall.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011, Vasiliy Kulikov wrote:

> If /proc/sys/kernel/modules_disabled is set to 1, then nobody (even full
> root) may not read/write arbitrary kernel memory.  In spite of it,
> hibernation allows anyone with an access to either /dev/snapshot or
> /sys/power/ make the full snapshot of the system.  This snapshot may be
> freely changed and uploaded back.

given that the user can boot a different OS entirely and modify the stored 
image, I don't see how this can work, even conceptually.

and tieing anything modules related to hibernation is just wrong, you are 
mixing completely different concepts (even if the implementation happens 
to be similar)

David Lang
