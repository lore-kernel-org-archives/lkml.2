Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1DUTAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:00:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50934 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab1DUTAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:00:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
Date: Thu, 21 Apr 2011 21:00:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com> <201104211823.21384.arnd@arndb.de> <20110421184713.GB29841@ericsson.com>
In-Reply-To: <20110421184713.GB29841@ericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104212100.18417.arnd@arndb.de>
X-Provags-ID: V02:K0:pReKvzYzFtT/vAFWnmYKtEAOES5KITSH4hQuchYWcG1
 YOX3TzUVqLFAgfCwE6kVh8OIreQG6X6e2a7uqGir+449tXvXoZ
 NH8bpeQq8Kuk9SAk2yLFVTbIWX59cA5It7sqYDH23my29ROpd0
 SbwQrIhc1UXaC6IyVZ9cmvF/npULVdFlUyJ2XEGxP082509uDs
 7n4de6lGYsQ9P/G1iKBQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 April 2011 20:47:13 Guenter Roeck wrote:
> On Thu, Apr 21, 2011 at 12:23:21PM -0400, Arnd Bergmann wrote:
> > 
> > I think the generalization of the ARM code is currently being worked
> > on, so this should be there soon.
> > 
> Any pointers ?
> 
I believe the most recent discussion is at
http://thread.gmane.org/gmane.linux.ports.arm.kernel/113631

	Arnd
