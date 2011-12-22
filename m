Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1LVBJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:09:11 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49462 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab1LVBJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:09:09 -0500
Message-ID: <1324516143.30527.154.camel@work-vm>
Subject: Re: RFC: android logger feedback request
From: john stultz <johnstul@us.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Tim Bird <tim.bird@am.sony.com>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Date: Wed, 21 Dec 2011 17:09:03 -0800
In-Reply-To: <1324514820.30527.148.camel@work-vm>
References: <4EF264C3.6000104@am.sony.com> <20111221231956.GB23859@suse.de>
	 <1324513091.30527.139.camel@work-vm> <20111222002719.GA18361@suse.de>
	 <1324514820.30527.148.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11122201-6078-0000-0000-000005E627B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 16:47 -0800, john stultz wrote:
> Also, if I understand correctly, logger also is able to store messages
> from hardware modems or other hardware that run their own micro-os in a
> central location. This may be closer to the pstore mce bits, but its not
> clear yet to me how much overlap is there.

Looking at the driver, this point seems to be inaccurate as well.  So
sorry for adding to any confusion here. 

thanks
-john

