Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2AZXqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:46:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2AZXqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:46:52 -0500
Date: Thu, 26 Jan 2012 15:46:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richard Purdie" <rpurdie@rpsys.net>
Subject: Re: [PATCH v2] backlight: new backlight driver for LP855x devices
Message-Id: <20120126154651.767c4e55.akpm@linux-foundation.org>
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812CD3EE5@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812CD3EE5@EXMAIL03.scwf.nsc.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012 22:24:02 -0800
"Kim, Milo" <Milo.Kim@ti.com> wrote:

> This patch supports TI LP8550/LP8551/LP8852/LP8553/LP8556 backlight driver.
> 
> The brightness can be controlled by the I2C or PWM input.
> The lp855x driver provides both modes.
> For the PWM control, pwm-specific functions can be defined in the platform data.
> And some information can be read via the sysfs(lp855x device attributes).
> 
> For the details, please refer to 'Documentation/backlight/lp855x-driver.txt'.
> 

I had a few little problems here.

- For some reason my email client doesn't like MIME quoted-printable
  and cannot correctly extract the plain text.  It appears that
  globally deleting =\n and globally replacing =3D with = fixes things.
  Ho hum.  I really should go see if this has been fixed, or hassle
  the sylpheed developer(s).

- The driver generates a great storm of scripts/checkpatch.pl
  whitespace warnings.  Things like using eight spaces instead of a
  tab.  These really should be fixed, so please take a look at the
  checkpatch output then resend?

