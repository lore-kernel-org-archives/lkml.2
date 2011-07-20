Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab1GTF1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 01:27:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58641 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1GTF1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 01:27:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110719224142.GT2357@linux.vnet.ibm.com>
References: <20110719224142.GT2357@linux.vnet.ibm.com>
Date: Wed, 20 Jul 2011 10:57:38 +0530
Message-ID: <CAM=x7SbY8Z8jmarRougaJPxxR8gHi2MKtCUkq8Yi4JYCBo=JAw@mail.gmail.com>
Subject: Re: Fw: RCU boot debug patch
From: RKK <kulkarni.ravi4@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: kernelmail.jms@gmail.com, linux-kernel@vger.kernel.org, cmm@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi paul,

On Wed, Jul 20, 2011 at 4:11 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Hello, Julie and Ravi,
>
> Although we arrived at a patch that worked for both of you, we never did
> identify exactly which RCU callback (or other issue) that was causing
> the problem.  It would be good to do this in case there is some other
> problem lurking that might bite us in the future.  Mingming has therefore
> put together the following diagnostic patch which should identify the
> callbacks, please see below.
>
> So could you please run this and let us know what you find?  There should
> at least be a message for artificial_callback().
>

 Do i need to  apply this patch on today's Linus master or on -rc7 ?



-- 
Warm Regards,
Ravi Kulkarni
