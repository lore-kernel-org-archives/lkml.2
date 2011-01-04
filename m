Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab1ADFUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:20:36 -0500
Received: from mail-ew0-f66.google.com ([209.85.215.66]:39941 "EHLO
	mail-ew0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1ADFUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:20:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wpfdu2M4rALsSkiU/Mb0b+l9vpYZbQ3ZWXDLNxJFitnaFKfmecj6acaZPTpykvYEzP
         C2c9RLCLLAnmIHDVaQvR14DiqpOWAHxo6igzjlyfX4Fwin632qpNmGBNkt5qWLbF9dJf
         eToEBslYfx9UJY9tVlpwrS8joOQNqzHuyaiX0=
Date: Tue, 4 Jan 2011 06:20:27 +0100
From: Tejun Heo <tj@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 17/32] scsi/ibmvstgt: use system_wq instead of vtgtd
 workqueue
Message-ID: <20110104052027.GC6748@mtj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-18-git-send-email-tj@kernel.org>
 <AANLkTimSmStMdz8KTQB2k+p2kcVpm9KghZV1xDfuTOS4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimSmStMdz8KTQB2k+p2kcVpm9KghZV1xDfuTOS4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 03, 2011 at 06:45:33PM +0100, Bart Van Assche wrote:
> No matter which storage target will go upstream, I'm afraid that this
> patch will conflict with it. See e.g.
> http://dchs.spinics.net/lists/linux-scsi/msg49105.html.

Ah, okay.  The full conversion is gonna span several devel cycles
anyway.  I'll re-convert ibmvstgt when the dust settles down.

Thank you.

--
tejun
