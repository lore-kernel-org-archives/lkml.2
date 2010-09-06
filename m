Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab0IFNuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 09:50:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54086 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0IFNut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 09:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=AxFI1NpEHwbQPpX1ozJBU5oh7GPo9DXbVk+fbZpMdajDpR0Q5snPWTx69laK3fRmxF
         PMMugPW9Z83sa/Exko4RFhKF32eYEfGED4Vk+Iu2MqLpbC4l97HhgibqGylbOn8FzeN8
         vTugOnNIrEQuoO6JF6jdN13465d3LklpunVTY=
MIME-Version: 1.0
In-Reply-To: <20100906071759.GB2356@schottelius.org>
References: <20100709170432.GA7691@schottelius.org>
	<20100709102935.60648095@virtuousgeek.org>
	<20100906071759.GB2356@schottelius.org>
Date: Mon, 6 Sep 2010 21:50:48 +0800
Message-ID: <AANLkTimhofj_=bij5QhY0jg9GDuH9_+axviY2DHq_6U1@mail.gmail.com>
Subject: Re: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 6, 2010 at 3:17 PM, Nico Schottelius
<nico-linux-20100709@schottelius.org> wrote:
> after some time away from the kernel sources, here my latest report
> using Linux on the X201:
>
>  vmlinuz-2.6.36-rc1-00051-g3b89f56
>  vmlinuz-2.6.36-rc2-00237-gd4348c6
>  vmlinuz-2.6.36-rc3
>
> all come up with a black screen at resume.

Same problem here. X201s. Haven't had time to bisect.

Jeff
