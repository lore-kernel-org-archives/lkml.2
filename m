Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab1JBStI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:49:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33298 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab1JBStD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:49:03 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.135.251]
In-Reply-To: <20110927013001.GA20588@ponder.secretlab.ca>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
 <1316948337-7924-2-git-send-email-ohad@wizery.com> <20110927013001.GA20588@ponder.secretlab.ca>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 2 Oct 2011 20:48:41 +0200
Message-ID: <CAK=WgbY+YN6aj4+RUdPz068+H+vtnEx0_SbKuKc++S4AHRS_hw@mail.gmail.com>
Subject: Re: [RFC 1/5] ARM: dev_archdata: add private iommu extension
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 4:30 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Blech.  Oh well.  Not much point in doing something different if x86
> uses a void*.

x86 probably does this because two different implementations needs to
plug their private data there: intel-iommu plugs there a 'struct
device_domain_info *' and amd_iommu uses it with a 'struct
iommu_dev_data *'.

On ARM we'd eventually end up with even a bigger variety, and I guess
that even if we'd use a type-safe member here, it would itself end up
having 'void *'.

If it looks reasonable to you, can I please have your Ack ?

Russell, can you please take a look too and ack/nack ?

Thanks,
Ohad.
