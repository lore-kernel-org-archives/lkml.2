Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657Ab1CDOm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:42:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39545 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759412Ab1CDOm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:42:28 -0500
From: "Nori, Sekhar" <nsekhar@ti.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>,
        "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 4 Mar 2011 20:11:56 +0530
Subject: RE: [PATCH v10 1/1] PRUSS UIO driver support
Thread-Topic: [PATCH v10 1/1] PRUSS UIO driver support
Thread-Index: Acvad7Vie4wPYYywQ6qYiO/Aj324hAAAiDmg
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C009039@dbde02.ent.ti.com>
References: <1299213772-21931-1-git-send-email-pratheesh@ti.com>
	<1299213772-21931-2-git-send-email-pratheesh@ti.com>
 <20110304142028.GD28175@local>
In-Reply-To: <20110304142028.GD28175@local>
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

Hi Hans,

On Fri, Mar 04, 2011 at 19:50:28, Hans J. Koch wrote:
> On Fri, Mar 04, 2011 at 10:12:52AM +0530, Pratheesh Gangadhar wrote:
> > diff --git a/include/linux/uio_pruss.h b/include/linux/uio_pruss.h
> > new file mode 100644
> > index 0000000..8c9b2c9
> > --- /dev/null
> > +++ b/include/linux/uio_pruss.h
> 
> That should go to arch/arm/mach-davinci/include/mach/
> and not to the top level include/linux/ directory.

It was put in here because this driver
will be used across two ARM architectures
(DaVinci and OMAP). Although it won't be used
outside of ARM at least in near future.

Thanks,
Sekhar

