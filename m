Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1ATVW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:22:58 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:58813 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1ATVW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:22:56 -0500
Subject: Re: sshd issues with 2.6.38-rc1
From: john stultz <johnstul@us.ibm.com>
To: Jesse Gross <jesse@nicira.com>
Cc: lkml <linux-kernel@vger.kernel.org>, apw@canonical.com
In-Reply-To: <AANLkTi=Un9x2FXfm+pHGj9eqyvTU1+x84XmMcnFDSuAF@mail.gmail.com>
References: <1295554842.2998.79.camel@work-vm>
	 <AANLkTi=Un9x2FXfm+pHGj9eqyvTU1+x84XmMcnFDSuAF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 13:22:53 -0800
Message-ID: <1295558573.2998.86.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 12:30 -0800, Jesse Gross wrote:
> On Thu, Jan 20, 2011 at 12:20 PM, john stultz <johnstul@us.ibm.com> wrote:
> > Just an FYI: I'm having problems sshing to a machine I just updated to
> > 2.6.38-rc1. The machine is running Ubuntu 10.10, and and 2.6.37 with the
> > same config doesn't seem to have a problem.
> >
> > The box is always pingable. But when I ssh in from a client, it just
> > hangs before authenticating.
> 
> It's likely the checksum offloading issue that was recently fixed in
> d402786ea4f8433774a812d6b8635e737425cddd

That was it! Thanks!
-john


