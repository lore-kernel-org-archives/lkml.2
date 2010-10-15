Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab0JOHxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:53:30 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:56800 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab0JOHx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:53:29 -0400
X-IronPort-AV: E=Sophos;i="4.57,335,1283745600"; 
   d="scan'208";a="23487573"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        Drivers <Drivers@analog.com>,
        "Frysinger, Michael" <Michael.Frysinger@analog.com>,
        "chrisv@cyberswitching.com" <chrisv@cyberswitching.com>
Date: Fri, 15 Oct 2010 08:53:24 +0100
Subject: RE: [PATCH 2/3] drivers: misc: ad525x_dpot: Fix part name typos in
 defines
Thread-Topic: [PATCH 2/3] drivers: misc: ad525x_dpot: Fix part name typos in
 defines
Thread-Index: Actr7i3ysX/ViUXlTa2IW00b18tpxgATQCjw
Message-ID: <544AC56F16B56944AEC3BD4E3D5917713094373CA1@LIMKCMBX1.ad.analog.com>
References: <1287046788-25122-1-git-send-email-michael.hennerich@analog.com>
	<1287046788-25122-2-git-send-email-michael.hennerich@analog.com>
 <20101014152138.6511e08b.akpm@linux-foundation.org>
In-Reply-To: <20101014152138.6511e08b.akpm@linux-foundation.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote on 2010-10-15:
> On Thu, 14 Oct 2010 10:59:47 +0200
> <michael.hennerich@analog.com> wrote:
>
>>
>>
>
> (changelog quoted in full!)
>
> What are the runtime effects of this change?

Hi Andrew,

Sorry, I should have used a more verbose change log.

There is no runtime effect by this change.
It frees up namespace for defines erroneously used.
This is required to actually support devices requiring
the namespace, added with [PATCH 3/3].

All defines touched have the same value defined, after the change.

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


