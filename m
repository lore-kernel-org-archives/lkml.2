Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab2KSNCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 08:02:53 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:60524 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232Ab2KSNCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 08:02:52 -0500
Message-ID: <1353330169.19434.7.camel@x61.thuisdomein>
Subject: Re: mfd: lpc_ich: NULL pointer dereference at (second) module
 removal
From: Paul Bolle <pebolle@tiscali.nl>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org
Date: Mon, 19 Nov 2012 14:02:49 +0100
In-Reply-To: <20121119002404.GD18738@sortiz-mobl>
References: <1352467148.1895.20.camel@x61.thuisdomein>
	 <1352741475.6008.16.camel@petert> <20121119002404.GD18738@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2012 13:02:50.0394 (UTC) FILETIME=[2DF217A0:01CDC656]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-19 at 01:24 +0100, Samuel Ortiz wrote:
> I just merged commit
> 5dc4dda91c86ef82bd53d77e5de50ec095b33e46 into my for-next branch and that one
> could fix that issue. Could you guys please give it a go ?

0) Applies cleanly to v3.6.7. Compiles cleanly too. No oops after the
(second or later) removal of lpc_ich. So this patch seems to do the
trick.

1) Could you please send this patch to stable too (when it finally hits
mainline, that is)? A quick glance suggests it can be backported to as
far v3.0 (but I only tested v3.6.y, see above).

Thanks,


Paul Bolle

