Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1DKUM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 16:12:58 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41961 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab1DKUM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 16:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K3zUqPVgf/nL6qRLwc1apx6xPn7o/1HUEJzIeNkgrV6aBbRe1i0vzfMDpC8Wz31EhK
         xqg6+8Ep+KWo6ocgpqAA6MIK7IYQNcyTwU8SoE5eaVimuIi1rtS9YshXnIMBlppM5Rh8
         Dhyhb+cTYJFaSw+MKwtNw+9xXTa43mbT1qNsw=
MIME-Version: 1.0
In-Reply-To: <4DA3350E.2060400@gmail.com>
References: <20110411093214.GA18215@rainbow>
	<4DA3350E.2060400@gmail.com>
Date: Mon, 11 Apr 2011 13:12:55 -0700
Message-ID: <BANLkTinDMZ+CyGCmzZu8cSz1L_yFXxm+vg@mail.gmail.com>
Subject: Re: [Regression?] Removed regulator support in ehci-omap
From: Steve Sakoman <sakoman@gmail.com>
To: Steve Calfee <stevecalfee@gmail.com>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>,
        Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 10:06 AM, Steve Calfee <stevecalfee@gmail.com> wrote:
> On 04/11/11 02:32, Dmitry Artamonow wrote:
>> Hi, guys!
>>
>> Can anyone explain why regulator support has been removed from ehci-omap
>> driver in commit 19403165 ("usb: host: omap: ehci and ohci simplification")[1]?
>> In 2.6.37/2.6.38 it was enough to apply simple patch[2] adding regulators
>> description to board file to make USB work on omap3evm board (because USB PHY
>> is powered via regulator). But now it won't work anymore in 2.6.39-rc2.
>> BTW, I suspect that this commit also broke USB on omap3pandora board, as it
>> defines "hsusb0" regulator supply in its board file:
>>
> Yes, And Beagleboard xm (and I suspect other beagleboard versions) has
> been broken in 2.6.39rc1+.

FWIW, EHCI is also broken on Overo in both rc1 and rc2.

Steve
