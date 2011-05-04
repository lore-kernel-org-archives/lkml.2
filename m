Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab1EDUCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:02:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:52768 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab1EDUCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:02:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,316,1301900400"; 
   d="scan'208";a="638003161"
From: "Luck, Tony" <tony.luck@intel.com>
To: "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andi Kleen <andi@firstfloor.org>, Vivek Goyal <vgoyal@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Wed, 4 May 2011 13:02:25 -0700
Subject: RE: [RFC] Kdump and memory error handling
Thread-Topic: [RFC] Kdump and memory error handling
Thread-Index: AcwKknHPm4B9OWXPQli28mwDT76P1gAAvF6g
Message-ID: <987664A83D2D224EAE907B061CE93D5301C53C9966@orsmsx505.amr.corp.intel.com>
References: <20110504193509.GA5342@in.ibm.com>
In-Reply-To: <20110504193509.GA5342@in.ibm.com>
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

Your first suggestion of a "slim" dump makes the most sense. The
purpose of a crash dump is a research resource to find out why
the system crashed - but in the case of a machine check, we already
have the reasons for the crash captured by the machine check handler.

Perhaps you could include __log_buf[] in the slim crash dump? Assuming
that the machine check is not a result of an uncorrectable error
in this memory range.

-Tony
