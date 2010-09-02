Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0IBUBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:01:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52983 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0IBUBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:01:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=PZVLuUqc4irCpR3/OIZ3GioFs4BLbzH5lhWdTqXNAg3Kaoo2+yRr8e71+3j40uhUav
         qIhz2pmCk8N3LVYLwYafe/s6Z08ksHx9iS59GiZ4vDBIu4wYp5pWDPPHdjbWMxKvIP1M
         d5zgEglyOSQFz3+ATXrfIrUknsE5GSIz+UClY=
MIME-Version: 1.0
In-Reply-To: <4C7FFB85.7000006@vlnb.net>
References: <4C7FFB85.7000006@vlnb.net>
From: Chris Weiss <cweiss@gmail.com>
Date: Thu, 2 Sep 2010 15:00:58 -0500
Message-ID: <AANLkTikYgSrW-fSRNBMU2DWYk2x1xQSAqKhoW1Lijj4N@mail.gmail.com>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features between different
 SCSI targets (SCST, STGT, IET, LIO) updated
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        iscsitarget-devel@lists.sourceforge.net, stgt@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Ross Walker <rswwalker@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 2:31 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> Hello,
>
> I updated the Linux SCSI targets comparison page
> http://scst.sourceforge.net/comparison.html, which compares features of
> the existing Linux SCSI target subsystems. The comparison includes SCST,
> STGT, IET and LIO. I added IET there, because it is the most used Linux
> iSCSI target at the moment.
.
.
>
> If you see I'm wrong somewhere or forgot something, you are welcome to
> correct me and I will fix that.
>
> Vlad
>

as a user following the potential inclusion of a kernel-space target,
iscsi specifically, I would be very interested in seeing what other
pluses the other frameworks have over scst, because if this chart is
accurate, all the other targets have quite a ways to go to catch up.

To me, lacking correct reserve and task management means "not ready
for public consumption".  Making any kernel change that does not have
RESERVE/RELEASE and full TM command support is only going to make
Linux look buggy and amateur-ish in the storage world.  Best to not
change anything than to implement something without them.  These 2
features alone are what helped me choose SCST in the first place.
