Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab2JKUpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:45:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49826 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2JKUpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:45:02 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Nishanth Menon <nm@ti.com>
Cc: <linux-pm@vger.kernel.org>, Liam Girdwood <lrg@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PM / OPP: Export symbols for module usage.
Organization: Deep Root Systems, LLC
References: <1349962774-19636-1-git-send-email-nm@ti.com>
Date: Thu, 11 Oct 2012 13:45:05 -0700
In-Reply-To: <1349962774-19636-1-git-send-email-nm@ti.com> (Nishanth Menon's
	message of "Thu, 11 Oct 2012 08:39:34 -0500")
Message-ID: <87k3uwagby.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> From: Liam Girdwood <lrg@ti.com>
>
> Export the OPP functions for use by driver modules.
>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> [nm@ti.com: expansion of functions exported]
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Liam Girdwood <lrg@ti.com>

Acked-by: Kevin Hilman <khilman@ti.com>
