Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0GGMWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 08:22:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42725 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab0GGMWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 08:22:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 7 Jul 2010 14:20:52 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH v3] firewire: cdev: check write quadlet request length to
 avoid buffer overflow
To: Clemens Ladisch <clemens@ladisch.de>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4C346B44.2020407@ladisch.de>
Message-ID: <tkrat.d41b80d60ff7d2cc@s5r6.in-berlin.de>
References: <4C29C1CA.1050705@ladisch.de>
 <tkrat.cb22c58cc57838c0@s5r6.in-berlin.de>
 <tkrat.e922615a6f88a33e@s5r6.in-berlin.de>
 <tkrat.b2582c62a3eaf0ab@s5r6.in-berlin.de> <4C346B44.2020407@ladisch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  7 Jul, Clemens Ladisch wrote:
> Stefan Richter wrote:
>> [...] Thus the only problem is that a bogus write quadlet
>> request with user-specified length of < 3 will put 1...4 random bytes
>> into the packet payload.  But this is the user's problem then, not the
>> kernel's.
> 
> But not being initialized, these are the kernel's bytes that get
> disclosed.

Yes.  In which way can this be exploited though?  For all practical
purposes, the signal-to-noise ratio of these 1...4 bytes seems to be 0.
-- 
Stefan Richter
-=====-==-=- -=== --===
http://arcgraph.de/sr/

