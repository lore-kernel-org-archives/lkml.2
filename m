Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2HHAy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 20:54:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42802 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2HHAyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 20:54:25 -0400
MIME-Version: 1.0
In-Reply-To: <201208080015.31359.rjw@sisk.pl>
References: <1343251216-24106-1-git-send-email-ccross@android.com>
	<201208080015.31359.rjw@sisk.pl>
Date: Tue, 7 Aug 2012 17:54:24 -0700
X-Google-Sender-Auth: iNQ7Id6LRcsOsHW2PaZ6H415hQk
Message-ID: <CAMbhsRT5pHkVWPf5u=+hqWhAgAD_kDb+DSSx+PG-nAJ5DHdhng@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: coupled: fix sleeping while atomic in cpu notifier
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 3:15 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, July 25, 2012, Colin Cross wrote:
>> The cpu hotplug notifier gets called in both atomic and non-atomic
>> contexts, it is not always safe to lock a mutex.  Filter out all events
>> except the six necessary ones, which are all sleepable, before taking
>> the mutex.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> Has this been applied already?

It's not in Linus' tree, and I haven't heard anything from Len.
