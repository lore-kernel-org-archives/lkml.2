Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab1KCDRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:17:37 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9647 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1KCDRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:17:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 02 Nov 2011 20:17:31 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "pavel@ucw.cz" <pavel@ucw.cz>, "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Date: Thu, 3 Nov 2011 08:47:26 +0530
Subject: RE: [PATCH v2] PM: fix runtime accounting calculation error
Thread-Topic: [PATCH v2] PM: fix runtime accounting calculation error
Thread-Index: AcyZvc2ne2OuTrp3THO0uZbdVoX89wAGTcTA
Message-ID: <D958900912E20642BCBC71664EFECE3E6D123A0E70@BGMAIL02.nvidia.com>
References: <1319791502-17937-1-git-send-email-vbyravarasu@nvidia.com>
 <201111030118.46895.rjw@sisk.pl>
In-Reply-To: <201111030118.46895.rjw@sisk.pl>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Thursday, November 03, 2011 5:49 AM
> To: Venu Byravarasu
> Cc: pavel@ucw.cz; len.brown@intel.com; gregkh@suse.de; linux-
> pm@vger.kernel.org; linux-kernel@vger.kernel.org; Peter De Schrijver
> Subject: Re: [PATCH v2] PM: fix runtime accounting calculation error
> 
> On Friday, October 28, 2011, vbyravarasu@nvidia.com wrote:
> > From: venu byravarasu <vbyravarasu@nvidia.com>
> >
> > With delta type being int, its value is made zero
> > for all values of now > 0x80000000.
> > Hence fixing it.
> >
> > Signed-off-by: venu byravarasu <vbyravarasu@nvidia.com>
> 
> Applied to linux-pm/linux-next.

Thanks Rafael.
Venu
