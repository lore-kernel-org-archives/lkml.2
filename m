Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab0KWI6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:58:12 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37931 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0KWI6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:58:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [PATCH 2/2] kmsg_dump: adding to reboot, halt, poweroff and emergency_restart path
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "marco.stornelli@gmail.com" <marco.stornelli@gmail.com>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        Aaron Durbin <adurbin@google.com>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2FE@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2FA@USINDEVS01.corp.hds.com> <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2FE@USINDEVS01.corp.hds.com>
Message-Id: <20101123175450.7BCE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Nov 2010 17:58:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  We need to know the reason why system rebooted in support service.
>  However, we can't inform our customers of the reason because
>  final messages are lost on current Linux kernel.
>  
>  This patch improves the situation above because the final messages 
>  are saved by adding kmsg_dump() to reboot, halt, poweroff and 
>  emergency_restart path.
> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

This patch doesn't have any notification consumer. It's too bad.
As far as I know, some poeple are now discussing to make generic
firmware access interface. perhaps your one can be integrate it.
Please see and join following discussion.


From: "Luck, Tony" <tony.luck@intel.com>
Subject: [RFC] persistent store



