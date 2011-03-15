Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab1CON6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 09:58:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58763 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab1CON6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 09:58:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device driver into misc
Date: Tue, 15 Mar 2011 14:58:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        mems applications <mems.applications@st.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "carmine.iascone@st.com" <carmine.iascone@st.com>,
        "matteo.dameno@st.com" <matteo.dameno@st.com>,
        "rubini@ipvvis.unipv.it" <rubini@cvml.unipv.it>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <201103151024.26436.arnd@arndb.de> <4D7F4DBA.1060502@cam.ac.uk>
In-Reply-To: <4D7F4DBA.1060502@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103151458.31390.arnd@arndb.de>
X-Provags-ID: V02:K0:51dIK852cQH4jIuTsdX8GNhGsX23/iWZH1IjqNUYnGi
 H/HfJWse6I3Kn+4LqAV5Jyk1z65aYzK0lC6TMbRAA5khvBNSiD
 IpPPvyAjQ7J4I9XCuUJfOmTFtLPxtOBvUb1r3X3t81JqoQt3P0
 YYOFXVM4Z8tkCWC/mSOE7VDMSRmTuYbwir1rcvuAbTA/ijKzru
 Efu5kcushLwgFzo1VB8PQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 March 2011, Jonathan Cameron wrote:
> Interfaces (well sysfs ones anyway) is an area we have hammered pretty hard.
> Arnd, if I you do have time to look at anything, take a look at the abi docs
> in drivers/staging/iio/Documentation/ (mainly sysfs-bus-iio).
 
Ok, I'll have a look.

	Arnd
