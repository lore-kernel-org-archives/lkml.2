Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab2CaKrL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 06:47:11 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:39971 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778Ab2CaKrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 06:47:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgGAM/fdk9XQENJ/2dsb2JhbABEgw+COLAwgwaBCIIJAQEFIxUeIgEQCxgCAgUWCwICCQMCAQIBJx4GDQEHAQGICagdkXmBL45VgRgEm1GKP4Jp
Message-ID: <4F76E054.8010301@computer.org>
Date: Sat, 31 Mar 2012 12:45:40 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@amd.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Lin Ming <ming.m.lin@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
References: <CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com> <Pine.LNX.4.44L0.1203291050580.1417-100000@iolanthe.rowland.org> <20120330010730.GA27346@ladygaga>
In-Reply-To: <20120330010730.GA27346@ladygaga>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/03/12 03:07, Aaron Lu wrote:
> When the ODD is put to zero power state, it will not be able to handle
> commands like CDROMEJECT. We have to power it up first and then handle
> the ioctl request. Currently, we only power back up the ODD when user
> press the eject button as explained above.

What about slot-loading optical drives, where the user does not first 
have to press a button to open the tray (due to a lack of tray)?

Jan
