Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183Ab1DMRNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:13:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:4598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890Ab1DMRNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:13:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,205,1301900400"; 
   d="scan'208";a="628055497"
From: "Luck, Tony" <tony.luck@intel.com>
To: Prarit Bhargava <prarit@redhat.com>, Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Date: Wed, 13 Apr 2011 10:13:20 -0700
Subject: RE: [PATCH -v2] x86, MCE: Drop default decoding notifier
Thread-Topic: [PATCH -v2] x86, MCE: Drop default decoding notifier
Thread-Index: Acv5/HdJo+pK7pw6RreNvkgbzyWA7QAATPcQ
Message-ID: <987664A83D2D224EAE907B061CE93D5301A97212BD@orsmsx505.amr.corp.intel.com>
References: <20110413132409.GB1900@gere.osrc.amd.com>
 <1302701810-2471-2-git-send-email-bp@amd64.org>
 <4DA5ACB2.1070505@redhat.com> <20110413141829.GE1987@aftab>
 <4DA5B1B1.5090905@redhat.com> <20110413142648.GB2791@aftab>
 <20110413143642.GC2791@aftab> <4DA5D6CC.9090500@redhat.com>
In-Reply-To: <4DA5D6CC.9090500@redhat.com>
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

> [Hardware Error]:  Run the above through 'mcelog --ascii' to decode.
>
> potentially many, many times.  The problem still is that there is no
> output to decode (in the default case).

printk_once()?

Giving the admin a hint on how to do their job is all well
and good - but no need to do so for each and every report.

-Tony
