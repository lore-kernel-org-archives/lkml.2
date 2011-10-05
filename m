Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057Ab1JECtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 22:49:42 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:56286 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032Ab1JECtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 22:49:41 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: Move hyperv out of the drivers/staging/ directory
Thread-Topic: Move hyperv out of the drivers/staging/ directory
Thread-Index: AQHMgsz6RKrGNTwArES7b9WKFRPV/ZVtC9VQ
Date: Wed, 5 Oct 2011 02:49:40 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081EBBB2@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1316708240-25048-1-git-send-email-kys@microsoft.com>
 <20110922170450.GA4490@suse.de>
 <6E21E5352C11B742B20C142EB499E048081E935D@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110922173618.GA5624@suse.de>
 <6E21E5352C11B742B20C142EB499E048081EB789@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20111004170415.GA1320@suse.de>
 <6E21E5352C11B742B20C142EB499E048081EB86F@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20111004193414.GA15672@suse.de>
In-Reply-To: <20111004193414.GA15672@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Tuesday, October 04, 2011 3:34 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org
> Subject: Move hyperv out of the drivers/staging/ directory
> 
> KY, how about the following patch?
> 
> Any objection from the virt developers about this?
> 
> KY, I'd like to get your signed-off-by before committing this, care to
> test this out and pass it around the other hyperv developers and then
> sign off on it?  Then I will be glad to commit this to my tree.

We completed the testing and everything is functional. Here is my sign-off:

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Regards,

K. Y


> 
> thanks,
> 
> greg k-h
> 

