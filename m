Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1HaOW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:22:57 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:8533 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab1HaOWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:22:54 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 37/46] Staging: hv: vmbus: Check for events before
 messages
Thread-Topic: [PATCH 37/46] Staging: hv: vmbus: Check for events before
 messages
Thread-Index: AQHMZOS65pNyxcizJ0egPcv4E4W8wJU0l/KAgAEL7dCAAH7lAIAA5jFg
Date: Wed, 31 Aug 2011 14:22:54 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B553D@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-37-git-send-email-kys@microsoft.com>
 <20110829180511.GA7167@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B52F7@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20110830173818.GC22868@kroah.com>
In-Reply-To: <20110830173818.GC22868@kroah.com>
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
> Sent: Tuesday, August 30, 2011 1:38 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 37/46] Staging: hv: vmbus: Check for events before
> messages
> 
> On Tue, Aug 30, 2011 at 05:06:39PM +0000, KY Srinivasan wrote:
> > > On Sat, Aug 27, 2011 at 11:31:36AM -0700, K. Y. Srinivasan wrote:
> > > > Conform to Windows specification by checking for events before messages.
> > >
> > > What specification?
> > >
> > > Care to provide a comment in the code that you are doing this in this
> > > explicit order because of some rule that the hypervisor imposes on us?
> >
> > I am not sure if this is documented anywhere (publicly). In talking to Windows
> > guys, they suggested this is the order in which it is done on Windows guests
> and suggested
> > I should do the same. I will see if there is some public documentation that
> specifies this.
> 
> All you need to do is just document it in the code and I'll be happy.
> We don't rely on external documentation for things to be changed, in
> fact, there usually isn't any such thing :)

Ok; will do.

Regards,

K. Y

