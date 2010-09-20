Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab0ITVkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:40:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab0ITVj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:39:57 -0400
Date: Mon, 20 Sep 2010 22:38:25 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>,
        Roland Dreier <rdreier@cisco.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        akpm@linux-foundation.org, Steve Wise <swise@chelsio.com>,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-rdma@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        netdev@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        Sean Hefty <sean.hefty@intel.com>, Roland Dreier <rolandd@cisco.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: [dm-devel] idr_get_new_exact ?
Message-ID: <20100920213825.GF30622@agk-dp.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	Roland Dreier <rdreier@cisco.com>, Ohad Ben-Cohen <ohad@wizery.com>,
	akpm@linux-foundation.org, Steve Wise <swise@chelsio.com>,
	linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-rdma@vger.kernel.org,
	Paul Mackerras <paulus@samba.org>, linux-i2c@vger.kernel.org,
	"Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
	netdev@vger.kernel.org,
	"Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
	Sean Hefty <sean.hefty@intel.com>,
	Roland Dreier <rolandd@cisco.com>,
	Hal Rosenstock <hal.rosenstock@gmail.com>
References: <AANLkTi=ZLupVyFR0e2v-TLpeNWdw1bVMZUAhgyxLJ7OV@mail.gmail.com> <adaiq20f90h.fsf@cisco.com> <4C97D197.9070703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C97D197.9070703@gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 11:26:47PM +0200, Tejun Heo wrote:
> I agree.  Wouldn't those users better off simply using radix tree?
 
Can't speak for the other users, but dm uses it both ways - normally
happy with any id (minor number), but sometimes user requires a specific
one.

Alasdair

