Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab1GAS1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:27:30 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:44062 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab1GAS11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:27:27 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 0/10 v6] PM / Domains: Support for generic I/O PM domains
Organization: Texas Instruments, Inc.
References: <201106112223.04972.rjw@sisk.pl> <201106252324.13454.rjw@sisk.pl>
Date: Fri, 01 Jul 2011 11:27:22 -0700
In-Reply-To: <201106252324.13454.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 25 Jun 2011 23:24:13 +0200")
Message-ID: <87fwmpyhyt.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Hi,
>
> Well, one more update. :-)
>
> This is the 6th version of the patchset adding support for generic I/O PM
> domains.  The majority of patches have had some small fixes here and there
> to make things work when CONFIG_PM_RUNTIME is unset.  In addition to that,
> to make the shmobile code introduced by the last patch work for
> CONFIG_PM_RUNTIME unset I had to add patches [8-9/10].  Patch [7/10]
> adds wakeup support that was missing from the previous version and I
> decided not to push patch [1/10] for 3.0 after all.

For everything but the shmobile specifics, which I didn't look at too
closely, and the changes for [7/10] that we agreed on:

Reviewed-by: Kevin Hilman <khilman@ti.com>

Thanks!

Kevin
