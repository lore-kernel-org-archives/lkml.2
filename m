Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab0IGNgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:36:43 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:34285 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754132Ab0IGNgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:36:40 -0400
Date: Tue, 7 Sep 2010 09:35:57 -0400 (EDT)
From: Dave Anderson <anderson@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: CAI Qian <caiqian@redhat.com>, tj@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Message-ID: <1317667916.1487751283866557110.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <471005677.1486991283866304732.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: crash failure with 2.6.36-rc3 vmcore
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Greg KH" <gregkh@suse.de> wrote:

> On Sat, Sep 04, 2010 at 10:06:25PM -0700, Guenter Roeck wrote:
> > I browsed through the code a bit. Looks like the module owner will need to make
> > the necessary changes. The code now seems to depend on kernel internal structure
> > elements. Not sure if that is a good idea in the first place. At least for
> > the attribute owner it will have to be changed to not depend on its existence.
> > 
> > Of course, one could also argue that the field should be re-introduced in 
> > the kernel to make the utility work w/o changes. However, I don't think it
> > would be a good idea to hold the kernel hostage for such problems.
> 
> You're kidding, right?  You should have tools flexable to handle the
> fact that the internal kernel structures change all the time like
> this.  If not, your tools are broken.

Greg,

You are exactly right -- I am the owner/maintainer of the crash utility,
and kernel changes such as this require changes to the tool all the time.

This whole thread should never have been brought up on this list, but I've
been away for a few days, and was unable to nip it in the bud.  It should
have been restricted to the crash-utility@redhat.com mailing list.

Sorry for all the noise...

Dave Anderson  
 

