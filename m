Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2J2AEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 20:04:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52783 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab2J2AEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 20:04:45 -0400
Date: Sun, 28 Oct 2012 17:04:40 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [ 026/105] ACPI: EC: Make the GPE storm threshold a module
 parameter
Message-ID: <20121029000440.GE6083@elie.Belkin>
References: <20121028231536.970033833@decadent.org.uk>
 <20121028231545.002108441@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121028231545.002108441@decadent.org.uk>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:

> 3.2-stable review patch.  If anyone has any objections, please let me know.
[...]
> commit a520d52e99b14ba7db135e916348f12f2a6e09be upstream.
>
> The Linux EC driver includes a mechanism to detect GPE storms,
> and switch from interrupt-mode to polling mode.  However, polling
> mode sometimes doesn't work, so the workaround is problematic.
> Also, different systems seem to need the threshold for detecting
> the GPE storm at different levels.

Not an objection, but this is a weird parameter.  How many false
interrupts per transaction should be expected?  Is there some fact
about the hardware or firmware that makes this a well defined number
on each machine?

Thanks,
Jonathan
