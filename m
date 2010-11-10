Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0KJMvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 07:51:32 -0500
Received: from ozlabs.org ([203.10.76.45]:55240 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755784Ab0KJMvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 07:51:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] virtio: fix format of sysfs driver/vendor files
Date: Wed, 10 Nov 2010 23:21:25 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic-pae; KDE/4.5.1; i686; ; )
Cc: Greg KH <greg@kroah.com>, virtualization@lists.osdl.org,
        linux-kernel@vger.kernel.org
References: <20101109222029.65f3e192@nehalam>
In-Reply-To: <20101109222029.65f3e192@nehalam>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011102321.26288.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 04:50:29 pm Stephen Hemminger wrote:
> The sysfs files for virtio produce the wrong format and are missing
> the required newline. The output for virtio bus vendor/device should
> have the same format as the corresponding entries for PCI devices.
> 
> Although this technically changes the ABI for sysfs, these files were
> broken to start with!

Agreed, and I don't think anyone currently uses them.

Applied,
Rusty.
