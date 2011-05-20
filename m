Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934593Ab1ETOIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:08:30 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:18329 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab1ETOI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:08:29 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: vmbus driver
Thread-Topic: vmbus driver
Thread-Index: AQHMFm8184rvumQ7c0KLvy9LhTr6cJSWGtyA//+P+eCAAH+JAP//kdQA
Date: Fri, 20 May 2011 14:08:22 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481FC313@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1305842785-30206-1-git-send-email-kys@microsoft.com>
 <20110520122649.GA550@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481FC2AF@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20110520132220.GA23390@infradead.org>
In-Reply-To: <20110520132220.GA23390@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, May 20, 2011 9:22 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: vmbus driver
> 
> On Fri, May 20, 2011 at 01:12:32PM +0000, KY Srinivasan wrote:
> > Well, the util driver that implements a range of other services such as KVP,
> > time synch, heartbeat etc. is also a client of the vmbus driver (perhaps not in
> the
> 
> The KVP driver is a different module as far as I can see.  But it really
> needs a lot of work, as no one should use the ugly connector interface
> for new code.  The closest equivalent is gennetlink, but I'd like to
> understand what it's actually supposed to do in practice.

Chris,

I wrote the KVP component of the util driver less than a year ago and 
This code was reviewed on this list before it was accepted. The KVP (Key Value Pair)
functionality supports host based queries on the guest. The data gathering in
the guest is done in user-mode and the kernel component of KVP is used to
communicate with the host. I am using the connector interface to support
communication between the kernel component and the user-mode daemon.
The KVP functionality is needed to integrate with the Microsoft management 
stack on the host.

Regards,

K. Y 
 

