Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0EGHK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 03:10:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56898 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab0EGHKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 03:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hS/BtesoYNAjKopRWnXUk85IEGwtfzkxHRx4KbuKWS0Ak8KeiNwuxAoJTW6Twc4kda
         JueKMAfRU4aaj51hSlBKdAXsIAhsPfya0s3xOy5pop1TqZNN0JALMIRNotDKBDRrS3AP
         1MbgDZpn2GgFv5Gzb8dPSTr//3cpegI0fQ+ZI=
Message-ID: <4BE3BCDF.4080604@gmail.com>
Date: Fri, 07 May 2010 10:10:23 +0300
From: roma1390 <roma1390@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] nfs kernel server causes: kernel BUG at include/linux/module.h:386!
References: <4BE257EF.9050904@gmail.com> <20100506060326.GA20846@kroah.com>
In-Reply-To: <20100506060326.GA20846@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
 > On Thu, May 06, 2010 at 08:47:27AM +0300, roma1390 wrote:
 >> Hello,
 >>
 >> after some nfs server start/stop i hit kernel bug on 2.6.26. There is 
hope[1] that this bug is fixed[2], and fix is merged[3] into 2.6.29. But there 
is missing bugfix for older stable kernels.
 >
 > 2.6.26 is not supported by the community anymore.

Sadly, the debian 5.0 (current stable) chose 2.6.26 as distribution kernel. Of 
course they do kernel as part of distribution support by them self.

 > Is this a problem on the latest 2.6.27-stable kernel release?  If so,
 > which specific patches in Linus's tree do you think resolves this?  Is
 > it just the 22945e4a1c7454c97f5d8aee1ef526 commit that is needed to be
 > added there?

Currently there isn't any free resources to do 2.6.27-stable testing. 
Switching from distribution kernel to custom one adds much more work for 
system admin, so this options is the last one none other will work.

If there is any demand to test 22945e4a1c7454c97f5d8aee1ef526, there can be 
such test done. But this issue was found only once, and on first hour after 
nfs server configuration was started.

So the average system uptime from 300 days without nfs droped to 1 hour with nfs.

Currently I didn't know how to reproduce this situation (and didn't tried). 
But as i found this issue is known, is faced by lot of people, and nfs 
maintainer states that 22945e4a1c7454c97f5d8aee1ef526 is cure to this problem.

