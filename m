Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0IIUWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 16:22:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58196 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0IIUWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 16:22:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] Add Support for Intel CPU Family 6 / Model 22 (Intel Celeron 540)
Date: Thu, 9 Sep 2010 22:22:32 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-next-20100907+; KDE/4.5.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        Andi Kleen <andi@firstfloor.org>,
        Patrick Simmons <linuxrocks123@netscape.net>,
        LKML <linux-kernel@vger.kernel.org>
References: <4C879EF4.90509@netscape.net> <20100909123102.GQ13563@erda.amd.com> <20100909184812.GT13563@erda.amd.com>
In-Reply-To: <20100909184812.GT13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009092222.33178.arnd@arndb.de>
X-Provags-ID: V02:K0:sBhiSZWeXS6SMPa/JjF9JlqudcrxikKGTGjMZsU0Afd
 VbJv5xS26ANPDiM88izHm/Z3HUqhiQX/hiG8EOmpr9HRxPQCRM
 MNajj5zEnu32l9SQQpvT1+FsFN7HCrlCGbikkSlUjOJL9XyMNi
 YfQ0Wj9MyewtYQcCvg6q3YAEITBFhUygsH88aCYFmEq4BGdcD6
 Ik92hDdsRrkynHuZWPhlQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 September 2010 20:48:12 Robert Richter wrote:
> On 09.09.10 14:31:02, Robert Richter wrote:
> > On 08.09.10 10:34:28, Patrick Simmons wrote:
> > > This patch adds CPU type detection for the Intel Celeron 540, which is 
> > > part of the Core 2 family according to Wikipedia; the family and ID pair 
> > > is absent from the Volume 3B table referenced in the source code 
> > > comments.  I have tested this patch on an Intel Celeron 540 machine 
> > > reporting itself as Family 6 Model 22, and OProfile runs on the machine 
> > > without issue.  The patch was made against Linux version 2.6.35.4 but is 
> > > so trivial that it should apply cleanly to anything relevant.  Please CC 
> > > me with any comments or questions as I am not subscribed to the list.

The patch looks fine, but please note that only some Celeron 540 use this,
while others are model 15. However all Core 2 Solo U2xxx and all desktop
Celeron 2xx/4xx are model 22 as well.

	Arnd
