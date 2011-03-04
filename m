Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703Ab1CDQHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:07:23 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:43092 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759631Ab1CDQHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:07:21 -0500
Date: Fri, 4 Mar 2011 17:05:22 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        "TK, Pratheesh Gangadhar" <pratheesh@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 1/1] PRUSS UIO driver support
Message-ID: <20110304160522.GE28175@local>
References: <1299213772-21931-1-git-send-email-pratheesh@ti.com>
 <1299213772-21931-2-git-send-email-pratheesh@ti.com>
 <20110304142028.GD28175@local>
 <B85A65D85D7EB246BE421B3FB0FBB593024C009039@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024C009039@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 08:11:56PM +0530, Nori, Sekhar wrote:
> Hi Hans,
> 
> On Fri, Mar 04, 2011 at 19:50:28, Hans J. Koch wrote:
> > On Fri, Mar 04, 2011 at 10:12:52AM +0530, Pratheesh Gangadhar wrote:
> > > diff --git a/include/linux/uio_pruss.h b/include/linux/uio_pruss.h
> > > new file mode 100644
> > > index 0000000..8c9b2c9
> > > --- /dev/null
> > > +++ b/include/linux/uio_pruss.h
> > 
> > That should go to arch/arm/mach-davinci/include/mach/
> > and not to the top level include/linux/ directory.
> 
> It was put in here because this driver
> will be used across two ARM architectures
> (DaVinci and OMAP). Although it won't be used
> outside of ARM at least in near future.

OK, I accept that. I'll review the rest soon.

Thanks,
Hans
