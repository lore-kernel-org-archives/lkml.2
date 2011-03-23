Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab1CWOZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:25:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab1CWOZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:25:08 -0400
Date: Wed, 23 Mar 2011 10:25:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Juerg Haefliger <juergh@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Support for global block IO throttling?
Message-ID: <20110323142505.GD13315@redhat.com>
References: <AANLkTikEYDdL08=DdJ7fLR08r6sWDCHbNoOuGhxGhm7G@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikEYDdL08=DdJ7fLR08r6sWDCHbNoOuGhxGhm7G@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 02:48:18PM +0100, Juerg Haefliger wrote:
> Hi,
> 
> Are there any plans to support global (per cgroup) IO throttling in
> the near future? I'm in need of this and would gladly work on it if
> nobody else is and if people think this is a useful feature. What I
> envision is that one can specify the limits of individual devices in a
> group but also specify the overall aggregate limit of the whole group.
> I just started looking at the throttling code and haven't quite
> figured it out yet so it might take me a bit to get up to speed.

Hi Juerg,

What's the use case? Why do you need global block IO throttling?

Thanks
Vivek
