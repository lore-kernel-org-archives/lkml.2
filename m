Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294Ab0HMDRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 23:17:34 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57073 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab0HMDRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 23:17:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AhqRhYtUyO4odVaSc86Uh+igzDxxP+d9OfYsceGp/q/UYH6B/khYJiWtpDvfwTtweO
         f24mCAGd7AQ514CwLYjLyuDgKmVSfsOELJtcnfQS2FJfO489az0KdHOFI2y1I1k6u1RR
         enj0QospSBuWoPJJRV6H5Pxz3/cOmlqD6KpMM=
Message-ID: <4C64B93A.5010403@lwfinger.net>
Date: Thu, 12 Aug 2010 22:17:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Jason Wessel <jason.wessel@windriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with commit deda2e81961e96be4f2c09328baca4710a2fd1a0
References: <4C64571F.6000606@lwfinger.net> <1281646368.4002.66.camel@localhost.localdomain>
In-Reply-To: <1281646368.4002.66.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2010 03:52 PM, john stultz wrote:
> 
> Ugh. I'm surprised it picks *this* loop to optimize instead of the
> similar one right above. I'm guessing its the local raw_nsecs value, but
> whatever.  Also surprised Jason's testing didn't hit this issue, but its
> probably a gcc version thing.
> 
> Regardless, I clearly need to give i386 more love in my testing.
> My profuse apologies.
> 
> As suggested by Linus, here's the do_div explicit version. It builds ok
> on i386 & x86_64, but I have not yet tested it. 
> 
> Larry, Jason: Could you verify it works for you (and avoids the original
> issue)?

This one builds for me with both compilers. It appears to run OK. As to the
original issue - I don't think I ever saw the problem. I'll leave that question
for Jason.

Larry
