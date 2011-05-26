Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab1EZPba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:31:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58196 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853Ab1EZPb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:31:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WMnUIduw2ayu5pYx2n+U2mRJW/L0tntjTGZZ6enhyiinPpPoi7+D7adsAx4J0vyNcu
         RVMDrOgVvdVKFWJ5U2vAq1Xe7xjG2iT0guvVzyFZe5fMkxYZUKEIwUg703D/L1PxkPYr
         JaQksFg7i4o4pDq1QMnHTUAE1nTyQiqMdqVkQ=
MIME-Version: 1.0
In-Reply-To: <4DDE58E9.1050307@canonical.com>
References: <20110519182702.GA3337@maxin>
	<4DDCFA6F.2020801@canonical.com>
	<BANLkTinaVB-Y3kVzU9vHYUJs5P7Ea_JhOg@mail.gmail.com>
	<4DDE58E9.1050307@canonical.com>
Date: Thu, 26 May 2011 16:31:27 +0100
Message-ID: <BANLkTimOkpfLSiHp0Dm+jxxtHfA3PSVG-A@mail.gmail.com>
Subject: Re: [PATCH] drivers: video: Remove useless checks
From: Maxin B John <maxin.john@gmail.com>
To: tim.gardner@canonical.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        airlied@redhat.com, lethal@linux-sh.org, james@albanarts.com,
        error27@gmail.com, randy.dunlap@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> IMHO mixing signed and unsigned comparisons like this is just wrong. Its
> unnecessarily complicated and misleading, especially for a device driver.

Yes. I do agree with you.

> Its likely that the reason the fb code got into this situation is because a
> type was changed from signed to unsigned whence long ago, and nobody has
> bothered to clean it up.

Thats possible. Similar useless checks are present in other subsystems
of the kernel as well.

WBR,
Maxin
