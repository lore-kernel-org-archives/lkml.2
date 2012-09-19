Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab2ISQvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:51:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64168 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272Ab2ISQve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:51:34 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq: OMAP: Check IS_ERR() instead of NULL for omap_device_get_by_hwmod_name
Organization: Deep Root Systems, LLC
References: <1347932747.6562.3.camel@phoenix> <201209182052.57414.rjw@sisk.pl>
Date: Wed, 19 Sep 2012 09:51:35 -0700
In-Reply-To: <201209182052.57414.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue, 18 Sep 2012 20:52:57 +0200")
Message-ID: <877grqj6qw.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Tuesday, September 18, 2012, Axel Lin wrote:
>> omap_device_get_by_hwmod_name() returns ERR_PTR on error.
>> 
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>
> Kevin, should I take this?

Yes, please.

Acked-by: Kevin Hilman <khilman@ti.com>

Thanks,

Kevin


