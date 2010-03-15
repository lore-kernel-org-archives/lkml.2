Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937136Ab0COXQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:16:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:64865 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410Ab0COXQa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:16:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,646,1262592000"; 
   d="scan'208";a="781059127"
From: "Othman, Ossama" <ossama.othman@intel.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 15 Mar 2010 16:16:02 -0700
Subject: RE: [PATCH] Intel Restricted Access Region Handler
Thread-Topic: [PATCH] Intel Restricted Access Region Handler
Thread-Index: AcrDopc+nldMTTT6RFuj8KoVrn0lAAA8nrGA
Message-ID: <A5FE05C4C76E4C4CAB15D9962B96FC950C9A6D184E@orsmsx510.amr.corp.intel.com>
References: <1268558064-7973-1-git-send-email-ossama.othman@intel.com>
 <20100314181040.GB28359@suse.de>
In-Reply-To: <20100314181040.GB28359@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: E+T0 GALJ HL12 JId4 JcPG M8SX OmeI QFra Sbn7 VLxQ WrHh
 XvMp aDGr eJJJ eqRm
 hBmR;3;ZwByAGUAZwBrAGgAQABzAHUAcwBlAC4AZABlADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHIAYQBuAGQAeQAuAGQAdQBuAGwAYQBwAEAAbwByAGEAYwBsAGUALgBjAG8AbQA=;Sosha1_v1;7;{48851D21-F7C2-433F-8851-49E6FFA6A357};bwBzAHMAYQBtAGEALgBvAHQAaABtAGEAbgBAAGkAbgB0AGUAbAAuAGMAbwBtAA==;Mon,
 15 Mar 2010 23:16:02
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAASQBuAHQAZQBsACAAUgBlAHMAdAByAGkAYwB0AGUAZAAgAEEAYwBjAGUAcwBzACAAUgBlAGcAaQBvAG4AIABIAGEAbgBkAGwAZQByAA==
x-cr-puzzleid: {48851D21-F7C2-433F-8851-49E6FFA6A357}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Randy,

> Can you also send me a patch, that adds a TODO file to the directory of
> this driver, that explains what you think needs to be done in order to
> get this code merged into the main portion of the kernel tree, and
> include your email address in it so that people who wish to send
> patches, know who to copy on them?
> 
> See the other drivers/staging/*/TODO files for an example of what is
> expected here.

I just resubmitted a consolidated patch that includes the TODO file you requested, as well as the kernel-doc related updates that Randy requested.  Randy, I know that you were not in a rush to get them.  I just wanted to get them out of the way.

Thanks!
-Ossama

