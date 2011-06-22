Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab1FVMHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:07:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59498 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1FVMHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=w1Y+tjsNpdepavdhMrfFSiPphFPNpE0csKpzUMbaEQ+BBiurgNYSuK8Jh9ee1QEnaZ
         4vS8RUrlItjnWOPV/IewGPU800GLVOa0TJ5h17rokl87LT+Bq3vJkglTolpdHhumTzaU
         g1MFb9OQCXuRuGPjEHXp6xbLUrtQUBagKlhPI=
MIME-Version: 1.0
In-Reply-To: <BANLkTinSFErFBaZgeL4x1oiaw7woewUNVQ@mail.gmail.com>
References: <BANLkTinSFErFBaZgeL4x1oiaw7woewUNVQ@mail.gmail.com>
Date: Wed, 22 Jun 2011 15:07:00 +0300
Message-ID: <BANLkTiksk02_SmP8ZWP8J4w0kPCdVr15mw@mail.gmail.com>
Subject: Re: threading problem
From: Daniel Baluta <daniel.baluta@gmail.com>
To: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        kernelnewbies <kernelnewbies@kernelnewbies.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Murali,

> I have a device driver which provides the IOCTL function for the
> application to interact.
>
> when the application sends the IOCTL CMD_GO, my driver has to toggle a
> GPIO every 500 m Sec. until a 3 minute timeout occurs or a CMD_STOP
> IOCTL is received.
>
> I tried the DECLARE_WORK, DECLARE_DELAYED_WORK and also
> kernel_thread() to meet this requirement with no success.
>

Could you please show us the code?

thanks,
Daniel.
