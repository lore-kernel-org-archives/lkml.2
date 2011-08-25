Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab1HYWgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 18:36:14 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42229 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755698Ab1HYWgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 18:36:13 -0400
X-Sasl-enc: CrFLH39c56wCULICfYKqN7OsB8rRpbwDe/6SZM6VPBRA 1314311772
Date: Thu, 25 Aug 2011 15:35:45 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 22/59] Staging: hv: vmbus: Get rid of the unused name
 field in struct hv_driver
Message-ID: <20110825223545.GA6055@kroah.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-22-git-send-email-kys@microsoft.com>
 <20110825212428.GA1617@kroah.com>
 <20110825212820.GA6770@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B360E@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B360E@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 10:27:40PM +0000, KY Srinivasan wrote:
> This was existing code and I realized it did not conform to the Linux
> Driver Model. I fixed it in the patch set I had sent earlier (110/117).
> Yesterday I only got up to 74 of the 117 patches that you commented on.
> I was planning to send the rest today. If it is ok with you, please don't fix it here
> As it would break everything else. This is existing code that I am fixing in the patch set
> I will send you shortly.

Oops, as you see, I applied it :)

And I applied the rest of your series, so you might want to re-test and
resync your next series of patches based on what I have in the
staging-next tree now.

thanks,

greg k-h
