Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1CKL4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:56:31 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42100 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1CKL4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:56:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=dMhARy45pqHc2x5qkLgAa4EjEg0jQe6IhHDvciBWXEYppy3pkoCLrzpGo9NbnHTv9v
         y63DiDtT7/xRy650oDdpZYAInEIJezS03s+w2NMiPfNHkJ5znvkDR8ycw2n7KdmtxdJt
         b5ucUJ7NHXgsNqlhaXuzYdJskEDh0KFyWWQIg=
MIME-Version: 1.0
In-Reply-To: <20110311111321.GA5553@siel.b>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
	<1299173174-348-3-git-send-email-torbenh@gmx.de>
	<1299180844.28285.111.camel@work-vm>
	<20110304064639.GD3824@riccoc20.at.omicron.at>
	<1299355687.28285.130.camel@work-vm>
	<20110306132834.GA11790@riccoc20.at.omicron.at>
	<20110311111321.GA5553@siel.b>
Date: Fri, 11 Mar 2011 12:56:29 +0100
X-Google-Sender-Auth: n8SErOw-z4xwidDAkbaiTBSIdnA
Message-ID: <AANLkTim9gBw2cZQNHCq4n-tR+b0R_Ha3t0nWPpqdQ7Zm@mail.gmail.com>
Subject: Re: [PATCH 2/3] ptp: add a software clock based on clock_monotonic_raw
From: Christian Riesch <christian.riesch@omicron.at>
To: torbenh <torbenh@gmx.de>
Cc: Richard Cochran <richardcochran@gmail.com>,
        john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        richard.cochran@omicron.at, tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Torben,

On Fri, Mar 11, 2011 at 12:13 PM, torbenh <torbenh@gmx.de> wrote:
> On the audio lists, we have a guy now claiming that software ptp would
> confuse the whole h/w ptp infrastructure. His main agenda seems to be to
> prevent a software only ptp/avb implementatation.

could you please post a link to that discussion?
Thanks,
Christian
