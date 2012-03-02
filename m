Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab2CBVno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:43:44 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16586 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab2CBVnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:43:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 02 Mar 2012 13:43:24 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Alan Ott <alan@signal11.us>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 2 Mar 2012 13:43:23 -0800
Subject: RE: [PATCH v2 0/6] ARM: Tegra: cleanup patches from Arnd Bergmann
Thread-Topic: [PATCH v2 0/6] ARM: Tegra: cleanup patches from Arnd Bergmann
Thread-Index: Acz4vNkqO3W2f142RrCzdtfaFYLZHgAAJWPg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BE861A73@HQMAIL01.nvidia.com>
References: <1330721884-8495-1-git-send-email-alan@signal11.us>
 <74CDBE0F657A3D45AFBB94109FB122FF17BE861A54@HQMAIL01.nvidia.com>
 <4F513DE3.9020707@signal11.us>
In-Reply-To: <4F513DE3.9020707@signal11.us>
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

Alan Ott wrote at Friday, March 02, 2012 2:39 PM:
> On 03/02/2012 04:04 PM, Stephen Warren wrote:
> > Alan Ott wrote at Friday, March 02, 2012 1:58 PM:
> >> Sorry for the mess yesterday....
> >> This is V2 of Arnd's Patch series from yesterday. Hopefully this one will be
> >> smoother.
> > There was feedback on at least patches 4 and 5 that doesn't appear to
> > have been incorporated into this updated version.
...
> For patch #5 (ARM: tegra: USB_ULPI needs USB), it didn't look to me like
> there was a resolution on that thread yesterday. On reading it again, if
> we change
>     select USB_ULPI if USB_SUPPORT
> to:
>     select USB_ULPI if USB
> for both Tegra 2 and 3, does that satisfy you and Arnd?

I believe so yes. Thanks.

-- 
nvpublic

