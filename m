Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030890Ab2CVU5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:57:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56960 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab2CVU5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:57:11 -0400
Date: Thu, 22 Mar 2012 16:56:49 -0400 (EDT)
Message-Id: <20120322.165649.32205268396882350.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, levinsasha928@gmail.com, nyh@il.ibm.com,
        nyh@math.technion.ac.il
Subject: Re: [PULL] vhost-net/virtio: fixes for 3.4
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120322082718.GA11258@redhat.com>
References: <20120320145010.GA31570@redhat.com>
	<20120322082718.GA11258@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 22 Mar 2012 13:56:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 22 Mar 2012 10:27:19 +0200

> On Tue, Mar 20, 2012 at 04:50:41PM +0200, Michael S. Tsirkin wrote:
>> The following changes since commit 5ffca28a4ac7abb8a254fafe6bd03b2f83667df7:
>> 
>>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/aia21/ntfs (2012-02-27 07:59:33 -0800)
>> 
>> are available in the git repository at:
>> 
>>   ra.kernel.org:/pub/scm/linux/kernel/git/mst/vhost.git for_davem
>> 
>>   (ssh url as git.kernel.org seems down at the moment, when it comes up
>>    git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git for_davem
>>    should be the equivalent).

Neither of these URL's work for me:

[davem@drr net]$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git for_davem
fatal: Couldn't find remote ref for_davem
[davem@drr net]$ git pull ra.kernel.org:/pub/scm/linux/kernel/git/mst/vhost.git for_davem
Enter passphrase for key '/home/davem/.ssh/davem': 
Permission denied (publickey).
fatal: The remote end hung up unexpectedly
[davem@drr net]$ 

If you're sending me signed pull requests that thus require a newer
version of GIT, please don't.
