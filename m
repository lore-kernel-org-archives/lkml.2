Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1H3Rnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:43:49 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42835 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab1H3Rnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:43:46 -0400
X-Sasl-enc: VjNDqEZBW/4CiJv1hsm/2GI5PyyUXiFxrjKxnsxGu/zH 1314726225
Date: Tue, 30 Aug 2011 10:38:18 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 37/46] Staging: hv: vmbus: Check for events before
 messages
Message-ID: <20110830173818.GC22868@kroah.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-37-git-send-email-kys@microsoft.com>
 <20110829180511.GA7167@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B52F7@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B52F7@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 05:06:39PM +0000, KY Srinivasan wrote:
> > On Sat, Aug 27, 2011 at 11:31:36AM -0700, K. Y. Srinivasan wrote:
> > > Conform to Windows specification by checking for events before messages.
> > 
> > What specification?
> > 
> > Care to provide a comment in the code that you are doing this in this
> > explicit order because of some rule that the hypervisor imposes on us?
> 
> I am not sure if this is documented anywhere (publicly). In talking to Windows 
> guys, they suggested this is the order in which it is done on Windows guests and suggested
> I should do the same. I will see if there is some public documentation that specifies this.

All you need to do is just document it in the code and I'll be happy.
We don't rely on external documentation for things to be changed, in
fact, there usually isn't any such thing :)

thanks,

greg k-h
