Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1LWVEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:04:44 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:61391 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab1LWVEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:04:42 -0500
Date: Fri, 23 Dec 2011 19:05:13 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: Szymon Janc <szymon@janc.net.pl>
Cc: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [REGRESSION] resume takes 10s longer due to e1b6eb3 (Bluetooth:
 Increase HCI reset timeout ...)
Message-ID: <20111223210513.GG5287@joana>
Mail-Followup-To: Szymon Janc <szymon@janc.net.pl>,
	=?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	Linux PM mailing list <linux-pm@vger.kernel.org>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <20111118184017.GA5052@nomi.cz>
 <20111121211506.GA16081@nomi.cz>
 <20111223165429.GA5287@joana>
 <201112232143.20937.szymon@janc.net.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <201112232143.20937.szymon@janc.net.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Szymon,

* Szymon Janc <szymon@janc.net.pl> [2011-12-23 21:43:20 +0100]:

> On Friday 23 December 2011 17:54:29 Gustavo Padovan wrote:
> 
> Hi,
> 
> > > On Mon, Nov 21, 2011 at 05:25:06PM +0200, Johan Hedberg wrote:
> > > > It might be worth to try out the two patches I just sent to
> > > > linux-bluetooth for HCI command failure tracking. They make sure that
> > > > failures are properly caught which should help avoid triggering the
> > > > timeout in certain scenarios (and yours might be one of them).
> > > 
> > > No, these don't help. :-(
> > 
> > Is this still happening? If yes I'm going to revert this patch.
> 
> I kindly ask to not revert this patch yet as this will bring back issue on my 
> CSR dongle.
> 
> If this regression still happening I can try investigate it next week (as long 
> as Tomáš is willing to provide more detailed logs and do some tests if 
> needed).

Sure, we can figure out what is going wrong for both of you, but until this
commit will reverted for safety.

	Gustavo
