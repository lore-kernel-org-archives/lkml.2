Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1AJSus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:50:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab1AJSur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:50:47 -0500
Date: Mon, 10 Jan 2011 19:43:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [BUG stable, 2.6.32.27] sched: delayed cleanup of user_struct
Message-ID: <20110110184303.GA12393@redhat.com>
References: <4D2AB8F7.7030506@profihost.ag> <20110110114913.GA22298@redhat.com> <20110110123630.GA27057@redhat.com> <4D2AFFB5.5000807@profihost.ag> <20110110133545.GA30163@redhat.com> <4D2B113A.2060303@profihost.ag> <20110110140817.GA31708@redhat.com> <4D2B1658.20201@profihost.ag> <20110110182317.GA16694@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110182317.GA16694@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10, Greg KH wrote:
>
> Tell us about what?  I'm totally confused here, what is the problem?

Please look at http://marc.info/?l=linux-kernel&m=129466345327931

I think that free_user's delayed logic is buggy, and the traces
from Stefan seems to confirm the theory.

As Mike suggests, we can just remove the deprecated USER_SCHED
code and forget about this problem.

Oleg.

