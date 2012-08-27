Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2H0Ubo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:31:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab2H0Ubn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:31:43 -0400
Message-ID: <503BD920.20603@redhat.com>
Date: Mon, 27 Aug 2012 13:31:28 -0700
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: mjw@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org,
        mtosatti@redhat.com, glommer@parallels.com, mingo@redhat.com
Subject: Re: [PATCH RFC 0/3] Add guest cpu_entitlement reporting
References: <20120823231346.11681.1502.stgit@lambeau>  <503BC298.3080306@redhat.com> <1346098984.8623.23.camel@lambeau>
In-Reply-To: <1346098984.8623.23.camel@lambeau>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 01:23 PM, Michael Wolf wrote:
> > 
> > How would a guest know what its entitlement is?
> > 
> > 
>
> Currently the Admin/management tool setting up the guests will put it on
> the qemu commandline.  From this it is passed via an ioctl to the host.
> The guest will get the value from the host via a hypercall.
>
> In the future the host could try and do some of it automatically in some
> cases. 

Seems to me it's a meaningless value for the guest.  Suppose it is
migrated to a host that is more powerful, and as a result its relative
entitlement is reduced.  The value needs to be adjusted.

This is best taken care of from the host side.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

