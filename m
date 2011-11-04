Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1KDRlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 13:41:40 -0400
Received: from nm33-vm7.bullet.mail.bf1.yahoo.com ([72.30.239.207]:27814 "HELO
	nm33-vm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751603Ab1KDRlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 13:41:39 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Nov 2011 13:41:39 EDT
X-Yahoo-Newman-Id: 240613.72417.bm@smtp217.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WSlFQe0VM1m3KS6f.7y6TyilXa4vu1RzgFr98MHtS74CtzA
 P3yExW.nWBqN.lFypogLfYcuGJnVGmVm.qQ19RRTz1Qcjl70V6mwFwDtO.Es
 RlAc_Lqu1FXi97ihuQkfq7EMSMkPyvqWqNmPOoquxNJM7NzwVYK_MfvgwAh_
 Nuhz3ml4E6ZAJrhYWVM3wcADrE0GJ.sVw1lQbzzHfCqayQfF2CkR_TzJ3.N9
 Hm5OUkdG8_LAg.PypA9Ikecc5tCRBBpjloPCLRjcUCv2xT7kbI0MMKZPyvc.
 BBwHrHqQZ8Epj5LE6YsZHjEEBNjJ8zWX9GHR6XPbWi8GHMnIT8YkFLv.E_1g
 y52.Y8T.ihO8qapXW6k6Npv7i6yX2jUF5NgOHl2CCf42VAy2MPVlmr3gaj9l
 9qpQNC6tz6t5RxnSqGB53deFOr.rOLBk0XC4YjYd.4vIpnugGvlzBjTDEq2U
 qru_mknFnc2Fxs9sE3PRu2sbmhQ--
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Fri, 4 Nov 2011 12:34:58 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, j.glisse@gmail.com
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111104173441.GA2157@zeus>
References: <20111101124759.GA1326@zeus>
 <20111102054658.GA29035@core.coreip.homeip.net>
 <20111102160208.GA6657@zeus>
 <20111102163109.GA29430@core.coreip.homeip.net>
 <20111103155956.GG4417@google.com>
 <20111103184559.GA3295@zeus>
 <20111103213959.GP4417@google.com>
 <20111104134347.GA2480@zeus>
 <20111104161431.GZ4417@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104161431.GZ4417@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 09:14:31AM -0700, Tejun Heo wrote:
> Andrew, can you please kill the X server after the hang and see
> whether that brings the system back?  I think sshd should still work
> and if not you can write a script to kill the X server after 30secs
> after resume (and kill that script if resume succeeds).

Hi Tejun & Jerome.

Tejun: My script killed X after a small wait from a bad resume. I am returned 
to the funcioning calling console. I can then re-start X and all subsystems
seem to working fine.

Jerome: I posted a post-bad-resume dmesg snippet with a GPU lockup warning
and trace here:

   http://article.gmane.org/gmane.linux.kernel/1210057

Did you need to see more?

Thanks.

~ Andy

