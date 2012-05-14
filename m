Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab2ENUdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:33:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:60475 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178Ab2ENUdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:33:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="152874378"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Please send a patch to set .gitignore to handle
 Documentation/misc-devices/mei/mei-amt-version
Thread-Topic: Please send a patch to set .gitignore to handle
 Documentation/misc-devices/mei/mei-amt-version
Thread-Index: AQHNMg3nWoFdKNjLsEac4wNG/im9xJbJuSRg
Date: Mon, 14 May 2012 20:33:24 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B102512@HASMSX103.ger.corp.intel.com>
References: <20120514201228.GA21466@kroah.com>
In-Reply-To: <20120514201228.GA21466@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> I'm tired of seeing Documentation/misc-devices/mei/mei-amt-version show
> up in 'git status' as an untracked file, care to please fix it up?

Oh right I forgot the .gitignore

Maybe we can add some CONFIG_ option to avoid unconditional  compilation 
of the example code, what do you think? 

> 
> But really, shouldn't binary files like this to into tools/ instead of
> Documentation?
I'm not sure it is really a tool it just really  example code.

There are other  examples of that e.g.  Documentation/watchdog/src/watchdog-test  and some more

Thanks
Tomas
