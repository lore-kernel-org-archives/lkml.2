Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1JQSwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:52:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab1JQSwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:52:37 -0400
Date: Mon, 17 Oct 2011 11:38:19 -0700
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v4 8_1/8] PCI, sys: Use device_type and attr_groups with
 pci dev
Message-ID: <20111017183819.GA18457@suse.de>
References: <4E9A3092.4080309@oracle.com>
 <4E9A3436.3010704@oracle.com>
 <20111016023943.GA3787@suse.de>
 <4E9A6CCB.4060101@oracle.com>
 <20111016155517.GA6421@suse.de>
 <4E9B6A2F.1080706@oracle.com>
 <20111017014527.GA7322@suse.de>
 <4E9C7386.6090607@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9C7386.6090607@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 11:27:18AM -0700, Yinghai Lu wrote:
> 
> We want to create rescan in sys only for pci bridge instead of all pci dev.

Much nicer, and the best part, the code is much smaller :)

> Also We could add more attr groups with is_visible to reduce messness in
> 	pci_create_sysfs_dev_files. ( at least for boot_vga one )

Yes, you probably should.

Thanks for making the changes.

greg k-h
