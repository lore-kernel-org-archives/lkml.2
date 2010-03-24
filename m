Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0CXP5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:57:37 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:38176 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0CXP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:57:36 -0400
Date: Wed, 24 Mar 2010 09:00:18 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: drago01 <drago01@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Jay Sternberg <jay.e.sternberg@linux.intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>, Greg KH <greg@kroah.com>
Subject: Re: iwl6050 firmware?
Message-ID: <20100324160018.GN15308@hexapodia.org>
References: <20100323221350.GA20509@hexapodia.org> <f6ca9fed1003240115s238ff0d4pc00e16be9f34a1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f6ca9fed1003240115s238ff0d4pc00e16be9f34a1e@mail.gmail.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 09:15:53AM +0100, drago01 wrote:
> > It's been several months since iwl6050 support was merged to mainline,
> >
> >    commit e1228374d648efe451973bc5f3d1f9a8e943ec0b
[snip]
> > but the firmware isn't yet in linux-firmware.git nor on
> 
> http://intellinuxwireless.org/iwlwifi/downloads/iwlwifi-6000-ucode-9.193.4.1.tgz
> ?
> 
> I don't think the 6050 need a separate firmware.

Yes, it does; it's asking for iwlwifi-6050-4.ucode on boot.  (I was
suprised too.)

-andy
