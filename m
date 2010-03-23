Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0CWWUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 18:20:37 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:43519 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0CWWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 18:20:36 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Mar 2010 18:20:36 EDT
Date: Tue, 23 Mar 2010 15:13:50 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Jay Sternberg <jay.e.sternberg@linux.intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>, Greg KH <greg@kroah.com>
Subject: iwl6050 firmware?
Message-ID: <20100323221350.GA20509@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's been several months since iwl6050 support was merged to mainline,

    commit e1228374d648efe451973bc5f3d1f9a8e943ec0b
    Author: Jay Sternberg <jay.e.sternberg@linux.intel.com>
    Date:   Mon Jan 19 15:30:34 2009 -0800

	iwlwifi: add recognition of Intel WiFi Link 6000 and 6050 Series

and hardware is shipping,

02:00.0 Network controller: Intel Corporation WiMAX/WiFi Link 6050 Series (rev 35)

but the firmware isn't yet in linux-firmware.git nor on
intellinuxwireless.org.

Any ETA on a release?

Thanks,
-andy
