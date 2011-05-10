Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab1EJV4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:56:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:13768 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1EJV42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:56:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,347,1301900400"; 
   d="scan'208";a="745343278"
From: "Luck, Tony" <tony.luck@intel.com>
To: David Miller <davem@davemloft.net>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "hadi@cyberus.ca" <hadi@cyberus.ca>,
        "daniel.lezcano@free.fr" <daniel.lezcano@free.fr>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        "renatowestphal@gmail.com" <renatowestphal@gmail.com>
Date: Tue, 10 May 2011 14:56:25 -0700
Subject: RE: [PATCH 0/7] Network namespace manipulation with file descriptors
Thread-Topic: [PATCH 0/7] Network namespace manipulation with file
 descriptors
Thread-Index: AcwOiWictlDJFPjTQf6XZMo0jqBNegA0xa1g
Message-ID: <987664A83D2D224EAE907B061CE93D5301CCC622F4@orsmsx505.amr.corp.intel.com>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
	<20110509.120408.48494155.davem@davemloft.net>
	<m1oc3btzk4.fsf@fess.ebiederm.org>
 <20110509.134007.116389415.davem@davemloft.net>
In-Reply-To: <20110509.134007.116389415.davem@davemloft.net>
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

>> The conflicts on syscall syscall numbers are an unfortunate pain.
>
> The way we've solved this before is the tree that cares pulls in
> the net-next-2.6 tree to resolve the conflict.

Actually it seems more common that new syscalls are only added to
x86 (plus one or more other architectures that the author cares
about). Then arch maintainers throw in a "wire up new syscalls"
patch during the merge window when they see these new bits show up.

-Tony

Oh - ia64 wiring looks good.

Acked-by: Tony Luck <tony.luck@intel.com>
