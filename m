Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1CHMiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:38:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab1CHMiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:38:20 -0500
Date: Tue, 8 Mar 2011 13:38:03 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/debugobjects] debugobjects: Add hint for better object
 identification
Message-ID: <20110308123802.GA2893@redhat.com>
References: <20110307085809.GA9334@redhat.com>
 <tip-be1e60006500eebfb3b82e0c0915ea898dfd224e@git.kernel.org>
 <alpine.LFD.2.00.1103081314100.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103081314100.2787@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 01:14:42PM +0100, Thomas Gleixner wrote:
> On Tue, 8 Mar 2011, tip-bot for Stanislaw Gruszka wrote:
> >  
> > +static void *work_debug_hint(void *addr)
> > +{
> > +	return ((struct work_struct *work) addr)->func;
Uhh.

> Care to send compilable patches ?
I'm sorry, it compile here with
gcc version 4.4.4 20100726 (Red Hat 4.4.4-13).

Could you fix it, or should I repost?

Stanislaw
