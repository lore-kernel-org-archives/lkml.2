Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0GAWuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:50:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab0GAWuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:50:03 -0400
Date: Thu, 1 Jul 2010 18:50:00 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: crypto / device-mapper regression.
Message-ID: <20100701225000.GA23432@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created an encrypted usb key a while ago under Fedora 12.
Today I upgraded my desktop to Fedora 13, and found I couldn't mount it any more.

https://bugzilla.redhat.com/show_bug.cgi?id=610278 has the details for
creation of the device, and the subsequent failure from ext2 (though it looks
more like either a failure in the crypto layer, or the device mapper code).

The filesystem was created under 2.6.32, and the failure appears under 2.6.33 and newer
(I just test .35rc3).  Did we have a bug in .32 that created bad images, or have
we regressed ?

anyone else seen this ?

	Dave
