Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab0G3RmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:42:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:63013 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759489Ab0G3RmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:42:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,288,1278313200"; 
   d="scan'208";a="591398664"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Fri, 30 Jul 2010 10:42:03 -0700
Subject: RE: e1000e crashes with 2.6.34.x and ThinkPad T60
Thread-Topic: e1000e crashes with 2.6.34.x and ThinkPad T60
Thread-Index: Acsv5p0nTR9Wc6UMSLarpVPZQCnw3gAJoQ3g
Message-ID: <8DD2590731AB5D4C9DBF71A877482A9001649C4653@orsmsx509.amr.corp.intel.com>
References: <20100724092644.GA13353@torres.zugschlus.de>
 <8DD2590731AB5D4C9DBF71A877482A9001623EC48E@orsmsx509.amr.corp.intel.com>
 <20100730125614.GB21444@torres.zugschlus.de>
In-Reply-To: <20100730125614.GB21444@torres.zugschlus.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 30, 2010 5:56 AM, Marc Haber wrote:
> On Mon, Jul 26, 2010 at 09:13:45AM -0700, Allan, Bruce W wrote:
>> Adding e1000-devel (the Intel LAN developers list).
>> 
>> Please supply the full dmesg you meant to attach with the original
>> report, as well as the output of lspci -vvv.
> 
> Stupid me.
> 
> Greetings
> Marc

Please also provide an eeprom dump from the wired LOM via 'ethtool -e ethX'.

Thanks,
Bruce.