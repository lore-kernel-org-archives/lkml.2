Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab2K0CHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 21:07:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49292 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab2K0CHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 21:07:04 -0500
MIME-Version: 1.0
Message-ID: <b46b84cf-3688-4fd7-b741-4e96f2663517@default>
Date: Mon, 26 Nov 2012 18:06:45 -0800 (PST)
From: Mary Mcgrath <mary.mcgrath@oracle.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: "Dave, Tushar N" <tushar.n.dave@intel.com>, netdev@vger.kernel.org,
        e1000-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: RE: [E1000-devel] 82571EB: Detected Hardware Unit Hang
References: <509B5038.8090304@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA89133487884@ORSMSX102.amr.corp.intel.com>
 <50A30656.6090508@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA8913348B105@ORSMSX102.amr.corp.intel.com>
 <50A43828.6000702@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA8913349A0B4@ORSMSX102.amr.corp.intel.com>
 <50A9C5CC.1030300@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA8913349EB41@ORSMSX102.amr.corp.intel.com>
 <50AB8471.7080607@oracle.com>
 <9B4A1B1917080E46B64F07F2989DADD62F2D62D6@ORSMSX102.amr.corp.intel.com>
 <50B41077.3080009@oracle.com>
In-Reply-To: <50B41077.3080009@oracle.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe
Thank you for working this.
I would love to find out how they expect a customer to make the modification
To  "word  0x1A, and see if the 8th bit is 0 or 1, and to change to 0."

I have in turn asked the ct for the lspci command on eth3, maybe the incorrect setting is upstream.

Again,  thank you.
Regards
Mary



-----Original Message-----
From: Joe Jin 
Sent: Monday, November 26, 2012 8:00 PM
To: Fujinaka, Todd
Cc: Dave, Tushar N; netdev@vger.kernel.org; e1000-devel@lists.sf.net; linux-kernel@vger.kernel.org; Mary Mcgrath
Subject: Re: [E1000-devel] 82571EB: Detected Hardware Unit Hang

On 11/27/12 00:23, Fujinaka, Todd wrote:
> If you look at the previous section, DevCap, you'll see that it's 
> correctly advertising 256 bytes but the system is negotiating 128 for 
> the link to the Ethernet controller. Things on the "other" side of the 
> link are controlled outside of the e1000 driver.
> 
> Tushar's first suggestion was to check the PCIe payload settings in 
> the entire chain. Have you done that? Mismatches will cause hangs.

Hi Todd,

So far I had to know how to modify the maxpayload size, since BIOS have not entry to change this, so I had to use ethtool, now I need to get the offset of MaxPayload size in eeprom, I ever tried to find from Intel online document but failed, any idea?

Thanks in advance,
Joe
