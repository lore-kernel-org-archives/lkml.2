Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab1DMFjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 01:39:00 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:43883
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016Ab1DMFi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 01:38:59 -0400
Date: Wed, 13 Apr 2011 07:38:48 +0200
From: Michael Guntsche <mike@it-loops.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.39-rc[12]] hangs during boot
Message-ID: <20110413053848.GA2730@gibson.comsick.at>
References: <20110408052921.GA17375@gibson.comsick.at>
 <20110409094134.GA12807@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110409094134.GA12807@sucs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 Apr 11 10:41, Sitsofe Wheeler wrote:
> On Fri, Apr 08, 2011 at 07:29:21AM +0200, Michael Guntsche wrote:
> > 
> > On a side note since I read similar reports already. This is a happening
> > with a CONFIG_NO_HZ/TICK_ONESHOT non-PREEMPT kernel.
> 
> Does the problem go away with a PREEMPT kernel?

Ok, I managed to get the serial console running in the meantime. If I
know boot and it hangs (with sysrq still working) what output would be
helpful for debugging this problem?

Kind regards,
Michael
