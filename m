Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1FDCll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 22:41:41 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:51245 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab1FDClk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 22:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=uAoVCr8jshSwcbNpUUvBhrkw4LxApYF+8mzvmbGN8qG96dA2e8lALYPu6xWmlS7UP2
         F/lQk8RqLzUkMQYEshxX1vrxOsHlduP5P+sVltPHcX2B8THuzsjZF9GIohzrFWsCUS6M
         1omBcxEe+ZeHWfW0pUYCCMOP1BijU3rSDOIto=
Date: Sat, 4 Jun 2011 10:41:19 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]remove warning for
 drivers/gpu/drm/i915/intel_ringbuffer.c
Message-ID: <20110604024117.GA2589@gmail.com>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	linux-kernel@vger.kernel.org
References: <20110603130502.GA5740@gmail.com>
 <yunei3arf48.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <yunei3arf48.fsf@aiko.keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 10:36:55AM -0700, Keith Packard wrote:
> On Fri, 3 Jun 2011 21:09:39 +0800, Harry Wei <jiaweiwei.xiyou@gmail.com> wrote:
> 
> > From: Harry Wei <harryxiyou@gmail.com>
> > When i compile kernel, it shows me two warnings
> > like below, so this patch can fix them.
> 
> This fix is already upstream; it wasn't included in the stable patch
> as it wasn't 'necessary' to fix the bug which is causing the warning
> (which ended up removing the last use of this function).
Hmmm..., i see.

Thanks
Harry Wei
