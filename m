Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab2FLMLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:11:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60272 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab2FLMLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:11:48 -0400
Message-ID: <4FD731F9.8070509@gmail.com>
Date: Tue, 12 Jun 2012 22:11:37 +1000
From: Jason Stubbs <jasonbstubbs@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: PROBLEM: Possible race between  xen, md, dm and/or xfs
References: <4FD1918A.2060908@gmail.com> <20120612035737.GL22848@dastard>
In-Reply-To: <20120612035737.GL22848@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-6-12 13:57 , Dave Chinner wrote:
> Nothing
> wrong with MD, LVM, or XFS. The problem is either that EBS never
> completed the IO, or Xen swallowed it and it never made to it to the
> guest OS. Either way, it does not appear to be a problem in the
> higher levels of the linux storage stack.

Thanks Dave for looking into this.

I'll be sure to give Amazon ample opportunity to diagnose things from
there side should the issue occur again and hopefully there won't be
any more people reporting extraneous issues.

--
Regards,
Jason Stubbs
