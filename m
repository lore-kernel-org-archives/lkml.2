Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1HaOV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:21:56 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:9269 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1HaOVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:21:55 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 44/46] Staging: hv: vmbus: Fix checkpatch warnings in
 connection.c
Thread-Topic: [PATCH 44/46] Staging: hv: vmbus: Fix checkpatch warnings in
 connection.c
Thread-Index: AQHMZOS6S19CXS4DvkWhhuBTQVevgJU0mSsAgAELvLCAAH7igIAA5EFg
Date: Wed, 31 Aug 2011 14:21:55 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B552C@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-44-git-send-email-kys@microsoft.com>
 <20110829180934.GB23618@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B5318@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110830174157.GD22868@kroah.com>
In-Reply-To: <20110830174157.GD22868@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, August 30, 2011 1:42 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 44/46] Staging: hv: vmbus: Fix checkpatch warnings in
> connection.c
> 
> On Tue, Aug 30, 2011 at 05:11:57PM +0000, KY Srinivasan wrote:
> > Thanks Greg. I will fix this. I got these patches out just before Hurricane Irene
> > hit the east coast. While we were lucky that it was not as bad as was predicted,
> > we lost power and we still don't have power. I have come to a public library in
> > a nearby town to check my email.  So, my responses will be sporadic over the
> > next couple of days (until we get power). I will try to address the issues you
> > have raised as quickly as possible.
> 
> Ouch, good luck with the power and other cleanup, hopefully you didn't
> have any water damage.
> 
> I'm in no rush for further patches, that's being driven by your end :)

Power was restored early this morning. Fortunately, except for lack power and
a few  broken branches, we did not really feel the brunt of this hurricane. I am starting
work on addressing the issues you and others have raised.

Regards,

K. Y
