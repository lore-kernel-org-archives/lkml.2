Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0GGLzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 07:55:50 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37677 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966Ab0GGLzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 07:55:48 -0400
X-Sasl-enc: OBVpHQQ1UxG8KB4+qxe7MSmT3/rtMH7fyMgx//qx6tno 1278503747
Message-ID: <4C346B44.2020407@ladisch.de>
Date: Wed, 07 Jul 2010 13:55:48 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] firewire: cdev: check write quadlet request length
 to avoid buffer overflow
References: <4C29C1CA.1050705@ladisch.de> <tkrat.cb22c58cc57838c0@s5r6.in-berlin.de> <tkrat.e922615a6f88a33e@s5r6.in-berlin.de> <tkrat.b2582c62a3eaf0ab@s5r6.in-berlin.de>
In-Reply-To: <tkrat.b2582c62a3eaf0ab@s5r6.in-berlin.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> [...] Thus the only problem is that a bogus write quadlet
> request with user-specified length of < 3 will put 1...4 random bytes
> into the packet payload.  But this is the user's problem then, not the
> kernel's.

But not being initialized, these are the kernel's bytes that get
disclosed.


Regards,
Clemens
