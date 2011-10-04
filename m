Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625Ab1JDUGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:06:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54529 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933403Ab1JDUF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:05:57 -0400
Subject: Re: [PATCH] dw_apb_timer: constify clocksource name
From: john stultz <johnstul@us.ibm.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110823125644.GL2796@pulham.picochip.com>
References: <1311608077-4759-1-git-send-email-jamie@jamieiles.com>
	 <20110823125644.GL2796@pulham.picochip.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 12:57:25 -0700
Message-ID: <1317758245.3112.935.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11100420-6078-0000-0000-000001762FE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 13:56 +0100, Jamie Iles wrote:
> On Mon, Jul 25, 2011 at 04:34:37PM +0100, Jamie Iles wrote:
> > The clocksource name should be const for correctness.
> > 
> > Cc: John Stultz <johnstul@us.ibm.com>
> > Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> 
> ping?

Terribly sorry this got so far back on my queue. I've applied it in my
tree and will push it for 3.2

thanks
-john

