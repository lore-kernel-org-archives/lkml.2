Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab0I2Mob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:44:31 -0400
Received: from mail.solarflare.com ([216.237.3.220]:46218 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab0I2Mo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:44:29 -0400
Subject: Re: [RFC] Online firmware upgrade in non-embedded systems
From: Ben Hutchings <bhutchings@solarflare.com>
To: dedekind1@gmail.com
Cc: netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        sf-linux-drivers <linux-net-drivers@solarflare.com>
In-Reply-To: <1285763658.2437.112.camel@localhost>
References: <1285696787.2282.45.camel@achroite.uk.solarflarecom.com>
	 <1285763658.2437.112.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 29 Sep 2010 13:44:26 +0100
Message-ID: <1285764266.2283.10.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2010 12:44:29.0370 (UTC) FILETIME=[0EA6A9A0:01CB5FD4]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17672.005
X-TM-AS-Result: No--24.088800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 15:34 +0300, Artem Bityutskiy wrote:
> On Tue, 2010-09-28 at 18:59 +0100, Ben Hutchings wrote:
> > Currently the sfc network driver is optionally combined with an MTD
> > driver (CONFIG_SFC_MTD) which exposes all upgradable firmware and
> > configuration partitions in flash.  This works nicely in kernels with
> > MTD enabled, but since MTD is mainly used in embedded systems with
> > on-board flash it is often disabled in distribution kernels and custom
> > kernels alike.  This leaves users of sfc unable to upgrade firmware
> > without rebuilding the kernel or booting some other distribution.  The
> > lack of widespread MTD support is a regular cause of support requests.
> 
> At least Fedora does have MTD enabled. But I guess commercial
> distributions like RHEL might have it disabled (but I did not check),
> and I think I could guess the reason for this.

RHEL 4 and 5 have it; the first RHEL 6 beta did not but this was changed
at my request.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

