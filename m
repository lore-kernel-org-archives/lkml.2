Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab0HCNs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:48:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43206 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab0HCNs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=LvVjyjTZt51w44j45fSnSOfA6UQQFbQldNDd249litd5EA3Nzee6smP4lfZTqFcXhB
         nphF19t/J+ZwYsceeXVJrXMmeG2cA7gSN3XZf6rwcKjFo/0wmiugWI6aU3KNJBaqAHCJ
         L8IoGfh/a/tGXFODsCpFub5nyRmd/87G4moY0=
MIME-Version: 1.0
In-Reply-To: <20100803103300.GB2635@sortiz-mobl>
References: <1280805041.27646.1.camel@mola> <20100803103300.GB2635@sortiz-mobl>
From: Ian Molton <ian@mnementh.co.uk>
Date: Tue, 3 Aug 2010 14:48:07 +0100
X-Google-Sender-Auth: K31qPvKolvsrkolwIn7X7MhzfvA
Message-ID: <AANLkTimrGuRdDTjeAPcJbgnousXYYvQKEdF6Z2Tk7MTu@mail.gmail.com>
Subject: Re: [PATCH] tc6393xb: fix wrong goto labels for error handling
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, didnt see your message Samuel :)

On 3 August 2010 11:33, Samuel Ortiz <sameo@linux.intel.com> wrote:
> On Tue, Aug 03, 2010 at 11:10:41AM +0800, Axel Lin wrote:
>> This patch corrects the error handling path.
> Applied, thanks.
>
> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
>
