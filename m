Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab0GDP4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 11:56:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57648 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab0GDP4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 11:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=fLqegHvTatBu7WUYiPhszBAwqCkTk0ivCJyl6zJmdhlJsx8uhUTogBR/TA87QO2Dx4
         2siIYnD/58Zjt269eT+Vm1Wrl6nlnldmmyui6RcporYFeEoWUit6P/TNMqfdiRgEL1wz
         dHR5PS7itpW4DZ+kb56Ndhc3KbpsMvBuN3e0I=
MIME-Version: 1.0
In-Reply-To: <20100701095812.GA1096@boggieman>
References: <cover.1277911345.git.siccegge@cs.fau.de> <80c10751fb5b7d9be55656ac35827a403a5d6b2b.1277911346.git.siccegge@cs.fau.de> 
	<20100701095812.GA1096@boggieman>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 4 Jul 2010 23:56:30 +0800
Message-ID: <AANLkTimnfYVORKIf4KMANCRqC_-iXmGs4UmuZzfdWacH@mail.gmail.com>
Subject: Re: [PATCH 25/33] Removing dead CORGI_SSP_DEPRECATED
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Christoph Egger <siccegge@cs.fau.de>,
       Russell King <linux@arm.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       "Uwe Kleine-K??nig" <u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 5:58 PM, Kristoffer Ericson
<kristoffer.ericson@gmail.com> wrote:
> On Wed, Jun 30, 2010 at 06:01:56PM +0200, Christoph Egger wrote:
>> CORGI_SSP_DEPRECATED doesn't exist in Kconfig, therefore removing all
>> references for it from the source code.
>>
>> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
>
> Cant see anything wrong with this.
>
> acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
>

Applied.
