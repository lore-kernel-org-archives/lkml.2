Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1AYPeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:34:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41076 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1AYPeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:34:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DxNUqMqb2OI9yKNf8RTPedPq9XyPdih7vPxU+FBHu56n6acpiaWfdFbodJwjLTA/aN
         nvU0Tb88nfgHdtVUPNf8OnKyTVks/coMWBHiPqfWiJNpx48Q4NEjKEceXVYKFQWm0Mp/
         2/L+mRy2PcWa6LftiAM0l5Qr1sQOaYBRSkyxc=
MIME-Version: 1.0
In-Reply-To: <20110125134722.GZ27510@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	<1294062595-30097-2-git-send-email-tj@kernel.org>
	<AANLkTimMK2Ec8SQiRyRBR+MdVKhAmMaaf+oa0VK3wWsf@mail.gmail.com>
	<20110104052421.GD6748@mtj.dyndns.org>
	<20110125134722.GZ27510@htj.dyndns.org>
Date: Tue, 25 Jan 2011 07:34:08 -0800
Message-ID: <AANLkTi=Z_ykZptzgi7kt3g21sebEV+hGN72iRcBDC1oC@mail.gmail.com>
Subject: Re: [PATCH 01/32] arm/omap: use system_wq in mailbox
From: Hari Kanigeri <hari.kanigeri@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

On Tue, Jan 25, 2011 at 5:47 AM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Jan 04, 2011 at 06:24:21AM +0100, Tejun Heo wrote:
>> Using dedicated workqueue or system_wq doesn't make any difference in
>> terms of execution latency anymore.  Sleeping work items no longer
>> delay execution of other work items.  If mailbox is very latency
>> sensitive, it might make sense to create a HIGHPRI workqueue but that
>> usually isn't necessary.
>
> Ping.  Shall I apply the patch?
>
I am sorry for the delay in acking your response.  Your patch looks good to me.

thank you,
best regards,
Hari
