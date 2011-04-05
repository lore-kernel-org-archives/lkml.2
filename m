Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1DEN6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:58:40 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:41802 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1DEN6i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:58:38 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/22] Staging: hv: Cleanup-storage-drivers-phase-III
Thread-Topic: [PATCH 00/22] Staging: hv: Cleanup-storage-drivers-phase-III
Thread-Index: AQHL82RMOk4IEvWhOkiZLVcIMcYu6JRPS3lw
Date: Tue, 5 Apr 2011 13:58:37 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E04802BFE3@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1301331615-26226-1-git-send-email-kys@microsoft.com>
 <20110405045904.GA4635@kroah.com>
In-Reply-To: <20110405045904.GA4635@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the confusion Greg. I reworked some patches in Phase-II cleanup and I was meaning to resend them before you began applying the patches, That is the reason for the problem you are encountering. I just resent the Phase II series. If you can back out the phase II that you have applied and apply the ones I resent, everything should apply cleanly. Once again, I sorry for creating additional work for you.

Regards,

K. Y

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, April 05, 2011 12:59 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/22] Staging: hv: Cleanup-storage-drivers-phase-III
> 
> On Mon, Mar 28, 2011 at 10:00:15AM -0700, K. Y. Srinivasan wrote:
> > This patch-set deals with some of the style isues in blkvsc_drv.c. We also
> > get rid most of the "dead code" in this file:
> >
> > 	1) Get rid of most of the forward declarations in this file.
> > 	   The only remaining forward declarations are to deal with
> > 	   circular dependencies.
> >
> > 	2) Get rid of most of the dead code in the file. Some of
> > 	   the functions in this file are place holders - they are not
> > 	   fuly implementedi yet (blkvsc_ioctl(), blkvsc_media_changed().
> > 	   We have retained some comments/dead code, to help us in the
> > 	   final implementation.
> 
> For some reason, this patch series fails to apply after the first one.
> So I've not applied any of them, care to resync and resend?
> 
> thanks,
> 
> greg k-h

