Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab2GMEKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 00:10:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:53041 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab2GMEKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 00:10:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="176776658"
From: "Dave, Tushar N" <tushar.n.dave@intel.com>
To: Joe Jin <joe.jin@oracle.com>
CC: "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: 82571EB: Detected Hardware Unit Hang
Thread-Topic: 82571EB: Detected Hardware Unit Hang
Thread-Index: AQHNXbA0O4dj/qIKzEaqpnXp2Y+l0pcimGMAgABDhtCAANf7AP//lehggAB9gwD//6IHIIAAe14A//+RAgAAESU+AAANp23AAB8MOIAADbt9YP//m9aAgAB1KHD//48GgIAASC6A///rKICAAG8OoP//oCeA//++GYD//qgHgP/9fRVQ
Date: Fri, 13 Jul 2012 04:10:51 +0000
Message-ID: <061C8A8601E8EE4CA8D8FD6990CEA891274F11FF@ORSMSX102.amr.corp.intel.com>
References: <4FFA9B96.6040901@oracle.com> <4FFCCA22.8060006@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274EEC8B@ORSMSX102.amr.corp.intel.com>
 <4FFCDA6C.8020708@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274EED74@ORSMSX102.amr.corp.intel.com>
 <4FFCF314.6020400@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274EEDD7@ORSMSX102.amr.corp.intel.com>
 <4FFD0908.6080506@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274EF8AD@ORSMSX102.amr.corp.intel.com>
 <4FFE3505.8060407@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274F018D@ORSMSX102.amr.corp.intel.com>
 <4FFE3D27.7020500@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274F01BE@ORSMSX102.amr.corp.intel.com>
 <4FFE40A9.4060807@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274F02D7@ORSMSX102.amr.corp.intel.com>
 <4FFE6BB9.4060106@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274F033B@ORSMSX102.amr.corp.intel.com>
 <4FFE787B.9050201@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274F0ACC@ORSMSX102.amr.corp.intel.com>
 <4FFF61BD.1060604@oracle.com>
In-Reply-To: <4FFF61BD.1060604@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Joe Jin [mailto:joe.jin@oracle.com]
>Sent: Thursday, July 12, 2012 4:46 PM
>To: Dave, Tushar N
>Cc: e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org
>Subject: Re: 82571EB: Detected Hardware Unit Hang
>
Thanks for sending full dmesg log. I am still investigating. I think this issue can occur if two PCIe link partner *i.e pcie bridge and pcie device do not have same max payload size.
I need 2 more info. 
1) PBA number of the card.
2) full lspci -vvv output of entire system 'after you have changed max payload size to 128'.

Thanks.

-Tushar
