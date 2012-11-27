Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab2K0A7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:59:49 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:31892 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab2K0A7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:59:48 -0500
Message-ID: <50B41077.3080009@oracle.com>
Date: Tue, 27 Nov 2012 08:59:35 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Fujinaka, Todd" <todd.fujinaka@intel.com>
CC: "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mary Mcgrath <mary.mcgrath@oracle.com>
Subject: Re: [E1000-devel] 82571EB: Detected Hardware Unit Hang
References: <509B5038.8090304@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA89133487884@ORSMSX102.amr.corp.intel.com> <50A30656.6090508@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA8913348B105@ORSMSX102.amr.corp.intel.com> <50A43828.6000702@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA8913349A0B4@ORSMSX102.amr.corp.intel.com> <50A9C5CC.1030300@oracle.com> <061C8A8601E8EE4CA8D8FD6990CEA8913349EB41@ORSMSX102.amr.corp.intel.com> <50AB8471.7080607@oracle.com> <9B4A1B1917080E46B64F07F2989DADD62F2D62D6@ORSMSX102.amr.corp.intel.com>
In-Reply-To: <9B4A1B1917080E46B64F07F2989DADD62F2D62D6@ORSMSX102.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/12 00:23, Fujinaka, Todd wrote:
> If you look at the previous section, DevCap, you'll see that it's
> correctly advertising 256 bytes but the system is negotiating 128 for
> the link to the Ethernet controller. Things on the "other" side of the
> link are controlled outside of the e1000 driver.
> 
> Tushar's first suggestion was to check the PCIe payload settings in the
> entire chain. Have you done that? Mismatches will cause hangs.

Hi Todd,

So far I had to know how to modify the maxpayload size, since BIOS have not
entry to change this, so I had to use ethtool, now I need to get the offset
of MaxPayload size in eeprom, I ever tried to find from Intel online document
but failed, any idea?

Thanks in advance,
Joe
