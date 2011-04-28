Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab1D1Muy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:50:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab1D1Mux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:50:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Weil, Oren jer" <oren.jer.weil@intel.com>
Subject: Re: [PATCH 7/8] staging/mei: AMT Watchdog
Date: Thu, 28 Apr 2011 14:50:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "david@woodhou.se" <david@woodhou.se>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com> <20110427150738.GE24596@suse.de> <F28B59AD52D84B479DCA469824475335065AF92EC7@hasmsx503.ger.corp.intel.com>
In-Reply-To: <F28B59AD52D84B479DCA469824475335065AF92EC7@hasmsx503.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104281450.42451.arnd@arndb.de>
X-Provags-ID: V02:K0:rJaxDHxhyefqU4uiKLUo9qMEowNtv5KWVcFSJu66xJo
 nIKvguWuF4t+KpfY+9rVUXmcZiKH9XY6yadzOyKnjWHmC5Zd8H
 YJYA0wbqLKWChzWahw2tCsXTK6POURbV3Zq8YSpNf+Yx0XBMYg
 gQwF+vx4T3fygv8HodzBnqTrix5poYZ5BBJhwzeSKGbvV4oOE5
 /V1PO3fxKG/2XikscX9WA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 April 2011, Weil, Oren jer wrote:
> 
> >On Wed, Apr 27, 2011 at 03:53:01PM +0200, Arnd Bergmann wrote:
> >> I still think this should be a regular watchdog driver using the
> >> drivers/watchdog user interface.
> >
> >I agree, Oren, if you are going to insist on doing things this way, you had
> >better describe why you are ignoring the existing kernel interfaces
> >provided.
> 
> we are not going to ignore the existing interfaces, it is one of our items
> in the TODO list.
> You can see the we move all of the Watchdog code to a single file so it
> would easy to us to take it later to other driver.
> Another Item on our TODO list is to expose Kernel function that equivalent
> to user interface so kernel clients 
> can access FW features/clients.

Ok, fair enough. Please put important information like this into the
changelog next time.

Also, your TODO file seems to be missing form the submission.

	Arnd
