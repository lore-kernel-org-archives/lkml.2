Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1BILk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:40:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56367 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1BILkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:40:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fRu+XGeYq3gna2z0bQgtHxchdmoVqPJoDD+6v7PLN9DStqFmU6Tu8nBp2YlJDqtto/
         l3OaaS+fdpsWJS06YXRJcMD0O+4g1S65eVNuh5hmJbxGjkhBTQF1u2X41IKrjKKx1LeE
         rsTKpVbUXnMEijmdoFdhW11J7F5jTqGoPbpSw=
MIME-Version: 1.0
In-Reply-To: <20110208181204.GF4476@core.coreip.homeip.net>
References: <1297157786-2004-1-git-send-email-kverlin@gmail.com>
	<20110208103923.GA2009@polaris.bitmath.org>
	<20110208181204.GF4476@core.coreip.homeip.net>
Date: Wed, 9 Feb 2011 14:40:53 +0300
Message-ID: <AANLkTi=C=3-VrM7L2bdCqY6WpiCLHS_uv-9R5gvPjBSD@mail.gmail.com>
Subject: Re: [PATCH] HID: added new driver for Panasonic Elite Panaboard
 UB-T780 and UB-T880
From: Anton Chikin <kverlin@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Chikin <anton.chikin@dataart.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Thank you for pointing me on tslib. Could you please provide some
documentation sources or examples for it?
As for custom parsing - as far as I remember - Jiri mentioned this
scenario in the discussion of hid subsystem
on input mailing list.

On Tue, Feb 8, 2011 at 9:12 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Feb 08, 2011 at 11:39:23AM +0100, Henrik Rydberg wrote:
>>
>> > +int xold = 0, yold = 0;
>>
>> static
>>
>
> Not even that. This is an USB device, not a platform one, so it shoudl
> be opssible to connect more than one to a box. All state should go into
> per-device structure.
>
> This is also does not appear to be a HID driver, really - it does not
> use HID infrastucture but does custom parsing.
>
> Calibration - normally we offload this task to userspace (tslib
> or other library/driver).
>
> Thanks.
>
> --
> Dmitry
>
