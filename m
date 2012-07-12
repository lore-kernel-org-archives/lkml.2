Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab2GLF56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:57:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:51617 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab2GLF5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:57:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167085299"
From: "Dave, Tushar N" <tushar.n.dave@intel.com>
To: Joe Jin <joe.jin@oracle.com>
CC: "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: 82571EB: Detected Hardware Unit Hang
Thread-Topic: 82571EB: Detected Hardware Unit Hang
Thread-Index: AQHNXbA0O4dj/qIKzEaqpnXp2Y+l0pcimGMAgABDhtCAANf7AP//lehggAB9gwD//6IHIIAAe14A//+RAgAAESU+AAANp23AAB8MOIAADbt9YP//m9aAgAB1KHD//48GgIAASC6A
Date: Thu, 12 Jul 2012 05:57:39 +0000
Message-ID: <061C8A8601E8EE4CA8D8FD6990CEA891274F02D7@ORSMSX102.amr.corp.intel.com>
References: <4FFA9B96.6040901@oracle.com> <4FFBDC50.5090800@oracle.com>
 <061C8A8601E8EE4CA8D8FD6990CEA891274EE41F@ORSMSX102.amr.corp.intel.com>
 <4FFCCA22.8060006@oracle.com>
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
In-Reply-To: <4FFE40A9.4060807@oracle.com>
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
>Sent: Wednesday, July 11, 2012 8:13 PM
>To: Dave, Tushar N
>Cc: e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org
>Subject: Re: 82571EB: Detected Hardware Unit Hang
>
>On 07/12/12 11:07, Dave, Tushar N wrote:
>>> -----Original Message-----
>>> From: Joe Jin [mailto:joe.jin@oracle.com]
>>> Sent: Wednesday, July 11, 2012 7:58 PM
>>> To: Dave, Tushar N
>>> Cc: e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>>> kernel@vger.kernel.org
>>> Subject: Re: 82571EB: Detected Hardware Unit Hang
>>>
>>> On 07/12/12 10:52, Dave, Tushar N wrote:
>>>> What is the exact error messages in BIOS log?
>>>
>>> Error message from BIOS event log:
>>> 07/12/12 05:54:00
>>>    PCI Express Non-Fatal Error
>>>
>>> Thanks,
>>> Joe
>Hi Tushar,
>
>Please find eeprom from attachment.

Do you have lspci -vvv dump of entire system before and after issue occurs? If you have can you send it to me?

