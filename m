Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1AYNqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:46:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38990 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1AYNqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:46:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gngne2102zbC9iS1G2sxdym+ZmNZ3eWBRmugIgHQkWAkEoSVwqGbOI2vcWYcP6ncuS
         FpAhfkk8AwyR1JjL2m0xpxTFMK8V+CeiJ8oZao5R0R0xXV2fo+VfcKcrqgq9ypVMml6v
         q7YFsYBIYyp1bS8jQKzg3xmvsg6yXVLE1e11s=
Date: Tue, 25 Jan 2011 14:45:58 +0100
From: Tejun Heo <tj@kernel.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        Stanislaw Gruszka <stf_xl@wp.pl>, linux-usb@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 20/32] video/msm_fb: use system_wq instead of dedicated
 workqueues
Message-ID: <20110125134558.GY27510@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-21-git-send-email-tj@kernel.org>
 <20110103170615.GB2285@redhat.com>
 <1294078245.18295.5.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294078245.18295.5.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 10:10:45AM -0800, Daniel Walker wrote:
> On Mon, 2011-01-03 at 18:06 +0100, Stanislaw Gruszka wrote:
> > On Mon, Jan 03, 2011 at 02:49:43PM +0100, Tejun Heo wrote:
> > > With cmwq, there's no reason to use separate workqueues.  Drop
> > > msmfb_info->resume_workqueue and use system_wq instead.
> > > 
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> > I'm not the right person, CC according to MAINTAINERS
> 
> ARM/QUALCOMM MSM MACHINE SUPPORT
> M:      David Brown <davidb@codeaurora.org>
> M:      Daniel Walker <dwalker@codeaurora.org>
> M:      Bryan Huntsman <bryanh@codeaurora.org>

Oops, sorry about that.  So how does the patch look?  Are you gonna
take it through msm tree or shall I take it?

Thanks.

-- 
tejun
