Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1DFW73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:59:29 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:44367 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab1DFW72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:59:28 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 00/22] Staging: hv: Cleanup-storage-drivers-phase-III
Thread-Topic: [PATCH 00/22] Staging: hv: Cleanup-storage-drivers-phase-III
Thread-Index: AQHL82RMOk4IEvWhOkiZLVcIMcYu6JRPS3lwgACKXgCAAZ8nYA==
Date: Wed, 6 Apr 2011 22:59:27 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E04802C5A7@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1301331615-26226-1-git-send-email-kys@microsoft.com>
 <20110405045904.GA4635@kroah.com>
 <6E21E5352C11B742B20C142EB499E04802BFE3@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20110405151046.GF28289@kroah.com>
In-Reply-To: <20110405151046.GF28289@kroah.com>
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



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, April 05, 2011 11:11 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 00/22] Staging: hv: Cleanup-storage-drivers-phase-III
> 
> 
> A: No.
> Q: Should I include quotations after my reply?
> 
> http://daringfireball.net/2007/07/on_top
> 
> 
> On Tue, Apr 05, 2011 at 01:58:37PM +0000, KY Srinivasan wrote:
> > Sorry for the confusion Greg. I reworked some patches in Phase-II
> > cleanup and I was meaning to resend them before you began applying the
> > patches, That is the reason for the problem you are encountering.
> 
> Huh?  I applied them in the order you sent them to me, how would that
> cause a patch to fail to apply properly?
> 
> > I
> > just resent the Phase II series. If you can back out the phase II that
> > you have applied and apply the ones I resent, everything should apply
> > cleanly. Once again, I sorry for creating additional work for you.
> 
> I can't back out anything, sorry.  I'll drop any pending patches you
> have sent me now.  Please resync with my staging git tree and resend
> them to properly apply and work.

Greg,

An upstream merge that occurred after the last tree closure was the cause of some of my patches not applying. I have fixed up all the patches and resent them for your consideration.

Regards,

K. Y

