Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0ITPl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:41:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab0ITPl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:41:56 -0400
Date: Mon, 20 Sep 2010 12:41:20 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping fixes 1/4] Fix kvmclock bug
Message-ID: <20100920154120.GB3088@amt.cnet>
References: <1284856695-19438-1-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284856695-19438-1-git-send-email-zamsden@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 02:38:12PM -1000, Zachary Amsden wrote:
> If preempted after kvmclock values are updated, but before hardware
> virtualization is entered, the last tsc time as read by the guest is
> never set.  It underflows the next time kvmclock is updated if there
> has not yet been a successful entry / exit into hardware virt.
> 
> Fix this by simply setting last_tsc to the newly read tsc value so
> that any computed nsec advance of kvmclock is nulled.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>

Applied, thanks.

