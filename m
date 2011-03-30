Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab1C3EuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 00:50:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62757 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab1C3EuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 00:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=hU3UVmJzO8yX5T/UF4Cqr2ADp74qN9s+yPlhaG5zrFw1Z5V/ZhxWQoEZr4DpCdVfBp
         N6NwbTw72BbOmiRK4dqFif//+nfGTs/BxyQ5TGjs/7Rl3Vl8wGduP88j+BC+kItJMkdH
         GJq45HOKvi9wnJvXLqHDvEGeh60CEitsPV/x8=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=AOXL==fgOwsY9ujFehYnsUFAQrvLy1CLwFEhu@mail.gmail.com>
References: <20110325133039.521553268@linutronix.de> <AANLkTi=AOXL==fgOwsY9ujFehYnsUFAQrvLy1CLwFEhu@mail.gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 30 Mar 2011 00:49:46 -0400
X-Google-Sender-Auth: 2eVFll8d76tA4GOv2mkXcyNHzHU
Message-ID: <AANLkTi=Ou2Vr1fa5yzmdJTGahMB=UUf4sUufh8AWrz21@mail.gmail.com>
Subject: Re: [patch 0/2] blackfin: Final irq cleanup
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 17:17, Mike Frysinger wrote:
> On Fri, Mar 25, 2011 at 09:32, Thomas Gleixner wrote:
>> this is the final cleanup and name space conversion, so that we can
>> remove the deprecated code in the core.
>>
>> It would be nice to get this Linus wards for .39
>
> does this require some other patch ?  a recent merge from another tree
> broke Blackfin, so i need to push out stuff to Linus again anyways.

hmm, so i guess you just merged this through your own tree ?
-mike
