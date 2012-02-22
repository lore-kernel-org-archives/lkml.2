Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2BVB67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:58:59 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:46521 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751637Ab2BVB65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:58:57 -0500
Message-ID: <1329875935.5143.24.camel@joe2Laptop>
Subject: RE: [PATCH] checkpatch: Add some --strict coding style checks
From: Joe Perches <joe@perches.com>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: David Miller <davem@davemloft.net>, Andy Whitcroft <apw@shadowen.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "andrei.emeltchenko.news@gmail.com" 
	<andrei.emeltchenko.news@gmail.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Feb 2012 17:58:55 -0800
In-Reply-To: <804857E1F29AAC47BF68C404FC60A18429B8F2@ORSMSX102.amr.corp.intel.com>
References: <20120221151435.GA19354@tuxdriver.com>
	 <20120221.144417.1445117001833888214.davem@davemloft.net>
	 <CAMXE1-qB8_5oGey2=Ypa5BitZnye3YqdM=yB8oKCGLvoZu_8HQ@mail.gmail.com>
	 <20120221.154053.2103818562080068513.davem@davemloft.net>
	 <1329857959.5143.11.camel@joe2Laptop>
	 <804857E1F29AAC47BF68C404FC60A18429B3EE@ORSMSX102.amr.corp.intel.com>
	 <1329874581.5143.22.camel@joe2Laptop>
	 <804857E1F29AAC47BF68C404FC60A18429B8F2@ORSMSX102.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-22 at 01:56 +0000, Allan, Bruce W wrote:
> > On Tue, 2012-02-21 at 22:09 +0000, Allan, Bruce W wrote:
> > > This appears to falsely complain about parenthesis alignment in
> > > conditional statements with multiple opening parentheses.
> > Can you try this one please?
[]
> It's better, but there are still instances of false hits AFAICT.

Do you have any examples?
The only one I noticed was spaces for alignment instead of tabs.
I think that's not a false hit myself.


