Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2DWSex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:34:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:5825 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab2DWSew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:34:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="144960673"
From: "Heasley, Seth" <seth.heasley@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ralston, James D" <james.d.ralston@intel.com>
Subject: RE: [PATCH 3/3] lpc_sch: Add Intel Centerton Multifunction Device
 support
Thread-Topic: [PATCH 3/3] lpc_sch: Add Intel Centerton Multifunction Device
 support
Thread-Index: AQHNHN7OVZLDEVRYmEOs38aIQI0D4Zag1K0A///ovoCAB9AOAIAAOAFg
Date: Mon, 23 Apr 2012 18:34:51 +0000
Message-ID: <DEC3922D1904474A8862C7BFF516EA9A41A6795A@ORSMSX101.amr.corp.intel.com>
References: <1334696962-3642-1-git-send-email-seth.heasley@intel.com>
 <20120418101802.GD1204@sortiz-mobl>
 <DEC3922D1904474A8862C7BFF516EA9A41A5CB9B@ORSMSX102.amr.corp.intel.com>
 <20120423081316.GA14577@sortiz-mobl>
In-Reply-To: <20120423081316.GA14577@sortiz-mobl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

>> >Is the pci_ids.h change already in ? If not, I should take it at the
>> >same time so that we don't break compilation.
>>
>> It was submitted just prior to my sending this patch.
>Please send it to me as your MFD patch build depends on it and it should
>be committed first.

Done.

>> I'm actually not submitting a watchdog patch.  The maintainer already
>has code for this driver and is converting it to the new watchdog API.
>In discussions with him, we agreed to the renaming of the driver, which
>was submitted for a previous platform.  He'll be committing the new code
>in the next couple of weeks, so I made this change in anticipation of
>the driver making it upstream.
>>
>That's reasonable, but I'd prefer this naming change to happen when the
>watchdog patch is submitted as well, as a separate MFD one liner patch.

Okay, that's no problem.  Do you need this patch resubmitted, or will you just nix the one line?

Regards,
Seth
