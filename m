Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0KKVi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:38:57 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35038 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab0KKVi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:38:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=h2UNjE+v5i/GoSFhneXsTD4DI9Qeo0c61SVbzCWzSw6eTUQ6U2vIXCGLRPjPXdAj7b
         zw1m74bwUwkWMXggdhkl3r/BqWmPodpLMOvfFu9OnYY1Mwk1OW9dvwlF0T5vw0tWs3Em
         j++LxOAakpCYklZ66QC6AmOXKiAsAoKbZpfTk=
MIME-Version: 1.0
In-Reply-To: <AANLkTikCajWfF9=7SLTxo+6PQFaLszZ9HwxJkbXNmTws@mail.gmail.com>
References: <AANLkTikCajWfF9=7SLTxo+6PQFaLszZ9HwxJkbXNmTws@mail.gmail.com>
Date: Thu, 11 Nov 2010 22:38:55 +0100
Message-ID: <AANLkTik0X6msJkm5M6y1hWMJStU=4E5LA+tBw=UwMVHD@mail.gmail.com>
Subject: Re: i915 on 2.6.37-rc1: backlight always off after "xset dpms standby"
From: Alex Riesen <raa.lkml@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 22:10, Alex Riesen <raa.lkml@gmail.com> wrote:
> an alternative way to reproduce it, is to just wait for screensaver.
> Only the backlight is off, it is possible to see the image on LCD
> matrix if you get the angle right.

Bugzilla bug:

https://bugzilla.kernel.org/show_bug.cgi?id=22672
