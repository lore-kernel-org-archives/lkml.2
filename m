Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1L1JPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 04:15:02 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54620 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab1L1JO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 04:14:56 -0500
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "arnd@arndb.de" <arnd@arndb.de>, "greg@kroah.com" <greg@kroah.com>,
        "eric.piel@tremplin-utc.net" <eric.piel@tremplin-utc.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Thread-Topic: [PATCH] lis3lv02d: Add STMicroelectronics lis33ldlh digital
Thread-Index: AQHMwTM0PN2tPvWpKkmNhYqSj7+eyZXo6n4AgAajA5A=
Date: Wed, 28 Dec 2011 09:14:38 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC103ECBA@DBDE01.ent.ti.com>
References: <1324617892-14576-1-git-send-email-anilkumar@ti.com>
 <20111223111807.GH2834@opensource.wolfsonmicro.com>
In-Reply-To: <20111223111807.GH2834@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.157.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Dec 23, 2011 at 16:48:08, Mark Brown wrote:
> On Fri, Dec 23, 2011 at 10:54:52AM +0530, AnilKumar Ch wrote:
> > This patch adds support for lis33ldlh digital accelerometer to the
> > lis3lv02d driver family. Adds ID field for detecting the lis33ldlh
> > module, based on this ID field lis3lv02d driver will export the
> > lis33ldlh module functionality.
> 
> You shouldn't send cover letters for single patches, if there's anything
> that needs saying it should be in the changelog for the patch.

Will take care from next time onwards

Regards
AnilKumar

