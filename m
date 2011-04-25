Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab1DYMKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 08:10:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55307 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469Ab1DYMKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 08:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DPJRc70mMg/6BQre5T2hLyyfDd+5RhitYPPL8+Lyadh3JffhiNXvP6AYK7zOVHgVav
         dbCVBn4K1aphv8g+q/rip5dxXAvYseVIwS8oKe/DUa4fggRY2NwA23rChb8Gcv7Qw5BB
         VFyJgI6MEMGHDk3mYF33qs6JFt42vjdWauvnI=
MIME-Version: 1.0
In-Reply-To: <BANLkTimLVPHdpcGqnZP-LNVT7Jp=XZ+gvw@mail.gmail.com>
References: <BANLkTi=fFg6+3DcBNwEOex0jASf1WiBRDQ@mail.gmail.com>
	<4DB4E94C.2060505@lwfinger.net>
	<BANLkTinA6GTTjP=MsVcCqmCA1Tgh-6bHjA@mail.gmail.com>
	<BANLkTimLVPHdpcGqnZP-LNVT7Jp=XZ+gvw@mail.gmail.com>
Date: Mon, 25 Apr 2011 20:10:12 +0800
Message-ID: <BANLkTikeATza--TG1sFzoPo=beCRsE4d_w@mail.gmail.com>
Subject: Re: r8712u cannot set essid
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: lkml <linux-kernel@vger.kernel.org>, wlanfae@realtek.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 7:14 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On Mon, Apr 25, 2011 at 12:32 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:


> wlan0: AP mode support not included in the build

Ok, fixed tihat with CONFIG_AP=y. But now, I get

wlan0: Driver does not support AP mode

I've tried "modprobe r8712u network_mode=4" but looks like it's not
putting in AP mode.


Jeff
