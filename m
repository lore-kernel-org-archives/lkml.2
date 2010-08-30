Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab0H3J6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:58:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51361 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab0H3J6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:58:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Xod0cFwoTAQ4N+bexSXW4YWBzin+AjvyTq8Sgozu/mrYN2jCiFCUpXIdyCYHXQMYsk
         dYuLA7GMlub2Q/Hyn4M80dTGNHdfdHyxSN30tuj0WRxonDZKVxL6SG+vnEw0/hnEp2DB
         J7VCwHzYRcMHBD6GT/Ge95DG+1nWKiSatFfuE=
MIME-Version: 1.0
In-Reply-To: <87wrr8cui7.fsf@turtle.gmx.de>
References: <87wrr8cui7.fsf@turtle.gmx.de>
Date: Mon, 30 Aug 2010 12:57:20 +0300
X-Google-Sender-Auth: zP7ByWUJG5wBYRnHLLd0VzEeIaU
Message-ID: <AANLkTi=SHwkFFNEUsbJR-eJnyWcDFXcWD-CRPN8uiSHK@mail.gmail.com>
Subject: Re: i915: wrong framebuffer size in 2.6.36-rc3
From: Pekka Enberg <penberg@kernel.org>
To: Sven Joachim <svenjoac@gmx.de>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ivan Bulatovic <combuster@gmx.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 12:36 PM, Sven Joachim <svenjoac@gmx.de> wrote:
> On my laptop which has a 1280x800 display, only the upper left 848x480
> pixels are used on the console in 2.6.36-rc3.  The resolution is
> correct, but /sys/class/graphics/fb0/modes looks like this:
>
> U:848x480p-0
>
> This is a regression from 2.6.35.  The graphics card according to lspci:
>
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
> 943/940GML Express Integrated Graphics Controller (rev 03)

Yeah, you're not alone on this:

http://lkml.org/lkml/2010/8/23/452
