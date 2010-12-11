Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0LKWox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 17:44:53 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:65177 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab0LKWot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 17:44:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=VJ+aWuj9Mx05iWRJB8PQAgOJEEEqW4/KHng6gHKzTeuEu1Ujjd1w55gN4EE7HziHM/
         2vojlJTJ1EjbtwhwpcrzX4V1j4Pt4R1telbO8F4iHV0heLOs/GAwu2VIeMkI3ZdY0Zg3
         BBngpknMm8+0qh0OJk1BNBeBz6de99FxX8BFs=
MIME-Version: 1.0
In-Reply-To: <20101211221325.GA1954@elf.ucw.cz>
References: <20101211221325.GA1954@elf.ucw.cz>
From: Matt Turner <mattst88@gmail.com>
Date: Sat, 11 Dec 2010 22:44:26 +0000
Message-ID: <AANLkTimMkee1-=qLQezBoq=4DNQDJ5mpFKmaoEn4VOZ9@mail.gmail.com>
Subject: Re: intelfb refuses to load
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        mbroemme@plusserver.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 10:13 PM, Pavel Machek <pavel@ucw.cz> wrote:

You want CONFIG_DRM_I915 and not CONFIG_FB_INTEL. The old framebuffer
driver should not be used in conjunction with xf86-video-intel.

Matt
