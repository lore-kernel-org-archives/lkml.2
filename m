Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1AZKmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:42:02 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57212 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1AZKmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:42:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cv4PqAVTnXJEMCopCrRcztaONPU1SGgwahU0ZL8Zz+fscYNkKJ09hQvnPUxB97RhKZ
         jvxhcZppzA0hvVFvBdADzwOiMUYhka0eqdrui4XRxRDv0mEaW41YVAoKoig/CPucSej8
         XhPWEFVY/PJGeMNj/RyJf/ABCKB3datbuM2/4=
Date: Wed, 26 Jan 2011 11:41:55 +0100
From: Tejun Heo <tj@kernel.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 20/32] video/msm_fb: use system_wq instead of dedicated
 workqueues
Message-ID: <20110126104155.GH12520@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-21-git-send-email-tj@kernel.org>
 <8yaoc74d0xw.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8yaoc74d0xw.fsf@huya.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 03:21:31PM -0800, David Brown wrote:
> On Mon, Jan 03 2011, Tejun Heo wrote:
> 
> > With cmwq, there's no reason to use separate workqueues.  Drop
> > msmfb_info->resume_workqueue and use system_wq instead.
> >
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> > Cc: linux-usb@vger.kernel.org
> > ---
> > Only compile tested.  Please feel free to take it into the subsystem
> > tree or simply ack - I'll route it through the wq tree.
> 
> I'll pull this into the MSM tree.

I suppose it will show up in linux-next?  I'm planning on marking
flush_scheduled_work() deprecated there soonish, so...

Thanks.

-- 
tejun
