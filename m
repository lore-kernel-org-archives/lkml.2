Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791Ab0FEXca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:32:30 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:52513 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933664Ab0FEXc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:32:28 -0400
Date: Sat, 5 Jun 2010 16:32:28 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Jay Sternberg <jay.e.sternberg@linux.intel.com>, Greg KH <greg@kroah.com>,
       drago01 <drago01@gmail.com>,
       reinette chatre <reinette.chatre@intel.com>,
       =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Subject: Re: iwl6050 firmware?
Message-ID: <20100605233228.GA25826@hexapodia.org>
References: <1269452733.2446.3138.camel@rchatre-DESK> <69e28c911003241324l1379abfcj782c8d16920450f3@mail.gmail.com> <20100323221350.GA20509@hexapodia.org> <1269452733.2446.3138.camel@rchatre-DESK> <20100323221350.GA20509@hexapodia.org> <f6ca9fed1003240115s238ff0d4pc00e16be9f34a1e@mail.gmail.com> <20100324160018.GN15308@hexapodia.org> <20100323221350.GA20509@hexapodia.org> <f6ca9fed1003240115s238ff0d4pc00e16be9f34a1e@mail.gmail.com> <20100323221350.GA20509@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323221350.GA20509@hexapodia.org>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 03:13:50PM -0700, Andy Isaacson wrote:
> It's been several months since iwl6050 support was merged to mainline,
> 
>     commit e1228374d648efe451973bc5f3d1f9a8e943ec0b
>     Author: Jay Sternberg <jay.e.sternberg@linux.intel.com>
>     Date:   Mon Jan 19 15:30:34 2009 -0800
> 
> 	iwlwifi: add recognition of Intel WiFi Link 6000 and 6050 Series
> 
> and hardware is shipping,
> 
> 02:00.0 Network controller: Intel Corporation WiMAX/WiFi Link 6050 Series (rev 35)
> 
> but the firmware isn't yet in linux-firmware.git nor on
> intellinuxwireless.org.
> 
> Any ETA on a release?

FWIW, iwlwifi-6050-ucode-9.201.4.1.tgz was released this past week, and
is working fine on my "Advanced-N + WiMAX 6250" 8086:0089 (rev 35) with
2.6.35-rc1-00194-gaef4b9a.

-andy
