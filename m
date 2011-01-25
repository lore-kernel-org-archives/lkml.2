Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1AYPhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:37:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56537 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab1AYPhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:37:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=H6/LLeJ+lo/syqh+NY4aNmArLsfNFNLhxzltHlDJSKSoUPwzMWQbR+i4Y2TJX+tD8+
         M4oqi6AIhcL/NWDK+iWC8HX8FTA1Xvpp4nbo89pm+U+NTYI5NqD133lF6TTEauIFmENM
         o1cJ0rF7HlNDGnki2Xi3guw7ksq4AVR9D8yB0=
Date: Tue, 25 Jan 2011 16:37:07 +0100
From: Tejun Heo <tj@kernel.org>
To: Hari Kanigeri <hari.kanigeri@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 01/32] arm/omap: use system_wq in mailbox
Message-ID: <20110125153707.GE27510@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-2-git-send-email-tj@kernel.org>
 <AANLkTimMK2Ec8SQiRyRBR+MdVKhAmMaaf+oa0VK3wWsf@mail.gmail.com>
 <20110104052421.GD6748@mtj.dyndns.org>
 <20110125134722.GZ27510@htj.dyndns.org>
 <AANLkTi=Z_ykZptzgi7kt3g21sebEV+hGN72iRcBDC1oC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Z_ykZptzgi7kt3g21sebEV+hGN72iRcBDC1oC@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 07:34:08AM -0800, Hari Kanigeri wrote:
> Tejun,
> 
> On Tue, Jan 25, 2011 at 5:47 AM, Tejun Heo <tj@kernel.org> wrote:
> > On Tue, Jan 04, 2011 at 06:24:21AM +0100, Tejun Heo wrote:
> >> Using dedicated workqueue or system_wq doesn't make any difference in
> >> terms of execution latency anymore.  Sleeping work items no longer
> >> delay execution of other work items.  If mailbox is very latency
> >> sensitive, it might make sense to create a HIGHPRI workqueue but that
> >> usually isn't necessary.
> >
> > Ping.  Shall I apply the patch?
> >
> I am sorry for the delay in acking your response.  Your patch looks good to me.

Thanks.  Acked-by added.

-- 
tejun
