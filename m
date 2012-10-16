Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab2JPJ2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:28:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60330 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2JPJ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:28:10 -0400
MIME-Version: 1.0
In-Reply-To: <20121015232147.GG2739@dastard>
References: <CAJ75kXZsBfhydOSF1Tjpp_OOndWs=jbC_YvrZ9Fw22+Q4rp1yw@mail.gmail.com>
 <20121015232147.GG2739@dastard>
From: William Dauchy <wdauchy@gmail.com>
Date: Tue, 16 Oct 2012 11:27:48 +0200
Message-ID: <CAJ75kXa0GeW1i5EgHgpuQEiTN0_bpFKpeZbCJqBkqLtq5hNRSA@mail.gmail.com>
Subject: Re: xfs: fix buffer lookup race on allocation failure
To: Dave Chinner <david@fromorbit.com>
Cc: stable@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        Mark Tinguely <tinguely@sgi.com>, Ben Myers <bpm@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

Thanks for your reply.

On Tue, Oct 16, 2012 at 1:21 AM, Dave Chinner <david@fromorbit.com> wrote:
> You're running a CONFIG_XFS_DEBUG kernel. If you can reproduce the
> problem with CONFIG_XFS_DEBUG, then it probably should be
> backported.

Yes indeed.

Tested-by: William Dauchy <wdauchy@gmail.com>
Cc: stable@kernel.org

-- 
William
