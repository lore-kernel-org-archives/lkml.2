Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab2K0GPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:15:49 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35890 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2K0GPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:15:47 -0500
Message-ID: <50B45A8A.4040307@kernel.org>
Date: Tue, 27 Nov 2012 01:15:38 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Julius Werner <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Sameer Nanda <snanda@chromium.org>,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH] cpuidle: Measure idle state durations with monotonic
 clock
References: <CAODwPW873M32d9zFT9fpJT9+PuMbz8htzUxdF1TNE+J1zR3jYA@mail.gmail.com> <1352944590-8776-1-git-send-email-jwerner@chromium.org> <3364211.o5ZCq4Y6Je@vostro.rjw.lan>
In-Reply-To: <3364211.o5ZCq4Y6Je@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>  drivers/idle/intel_idle.c                       |   14 +-----

Acked-by: Len Brown <len.brown@intel.com>

thanks!
-Len

