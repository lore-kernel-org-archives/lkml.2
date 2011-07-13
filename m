Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab1GMSP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 14:15:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:24139 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab1GMSPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 14:15:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,526,1304319600"; 
   d="scan'208";a="27300825"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>, Matthew Garrett <mjg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 13 Jul 2011 11:15:24 -0700
Subject: RE: pstore dump inside an nmi handler
Thread-Topic: pstore dump inside an nmi handler
Thread-Index: Acw/4MSAJfizKsMfSH+XD/SEypVeBgBpopWA
Message-ID: <987664A83D2D224EAE907B061CE93D5301E9C9F4A8@orsmsx505.amr.corp.intel.com>
References: <20110708201731.GA3025@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E981AB56@orsmsx505.amr.corp.intel.com>
 <20110708214941.GA20511@srcf.ucam.org> <20110711153931.GA10083@redhat.com>
In-Reply-To: <20110711153931.GA10083@redhat.com>
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

> But perhaps, if we detect a spinlock is in use, we can bust it and reset
> the state machine to solve that problem?

The ERST table specifies a series of actions to perform to make
the records get saved to (or read from) the platform persistent
store. These actions will be dependent on the h/w, and also on
the creativity of the BIOS writer who composed the ERST action
table.

Resetting the state machine looks like it might be tricky from
any arbitrary point in the sequence.

-Tony
