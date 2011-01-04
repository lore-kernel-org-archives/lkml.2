Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab1ADFSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:18:04 -0500
Received: from mail-ey0-f194.google.com ([209.85.215.194]:43379 "EHLO
	mail-ey0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1ADFSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:18:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ma4xj67tyNuv0rpOwQOIk3MYpL+y1HT9KY9WlrhhKfcOFW87gFBhhbegSvT4w/I2IF
         SPPOtDvHe01cdoWqA+fvvPIWZp8N7BArVmWxZWGEm4CXZCJ4TfPRxMR0BtqHFH3dDPWD
         I+4DcgZEJALRBw5t27cKZwprkL5/MrnP1UU9A=
Date: Tue, 4 Jan 2011 06:17:51 +0100
From: Tejun Heo <tj@kernel.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: castet.matthieu@free.fr, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, stf_xl@wp.pl
Subject: Re: your mail
Message-ID: <20110104051751.GB6748@mtj.dyndns.org>
References: <1294072680.4d21fb68cbdcf@imp.free.fr>
 <20110103170308.GA2285@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110103170308.GA2285@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 06:03:17PM +0100, Stanislaw Gruszka wrote:
> On Mon, Jan 03, 2011 at 05:38:00PM +0100, castet.matthieu@free.fr wrote:
> > could you CC me on ueagle-atm.c patches.

Will try to, but maybe it's a good idea to add a MAINTAINERS entry?

> > From what I remind we sleep in the workqueue, that's why we couldn't use the
> > system one (freeze keyboard...). But may be the code changed.
> In case when firmware is not available we can sleep for a few seconds in
> work function. That's block keyboard driver who also use common workqueue.
> If recent Tejun workqueue rewrite allow to long sleep in work func and
> not hurt other workqueue users, patch is ok.

Yeap, work items can sleep all they want on the system_wq.  It won't
delay execution of other work items.

Thanks.

--
tejun
