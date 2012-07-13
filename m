Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab2GMDXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 23:23:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab2GMDXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 23:23:11 -0400
Message-ID: <1342149765.31095.9.camel@cr0>
Subject: Re: [PATCH 2/2] Made core dump functionality optional
From: Cong Wang <amwang@redhat.com>
To: Alex Kelly <eshink@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Nikhil Rao <ncrao@google.com>,
        Dan Ballard <dan@mindstab.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 13 Jul 2012 11:22:45 +0800
In-Reply-To: <CAH08tp_5CNnK68G4BpZ+d_V9OMwEt8hC_pbtNovgSCTnGYd0hg@mail.gmail.com>
References: <1341275894-9737-1-git-send-email-alex.page.kelly@gmail.com>
	 <1341275894-9737-2-git-send-email-alex.page.kelly@gmail.com>
	 <CAM_iQpVu6DV+LnTNbDUxUmjA+NXM2WCwWB0StCh+bwD5Gn_zbg@mail.gmail.com>
	 <20120703050908.GA14527@leaf>
	 <CAH08tp_5CNnK68G4BpZ+d_V9OMwEt8hC_pbtNovgSCTnGYd0hg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 13:22 -0700, Alex Kelly wrote:
> Sorry it took me so long to reply to this:
> 
> 1. *Should* I change the option to CONFIG_CORE_DUMP ? I agree with Josh
> that in terms of the existing codebase, either way makes sense, but I'll
> defer to your judgment if you think I should change it.

Yeah, I agree.

> 
> 2. Is there a particular maintainer I should send this to if I hope to get
> it pushed upstream?
> 

I think Andrew Morton will take the patch.

Thanks.

