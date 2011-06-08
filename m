Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1FHIb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:31:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54669 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab1FHIb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=O0xJqi1lzflDF7wMb4y1MTor2RFlNNG5uSt9B9lTwTueuxfCQS2BXPFVzURK//QUj4
         fxpo5AAGIM+HXRgT7cWrZGkLqMqHkS8QN+SB1TdpHihJu1lrgRGlnyhONv0Pv48raR6q
         IS/5pp6DKVENwtA9MFRpXCzP8GIkZEH++HY80=
MIME-Version: 1.0
In-Reply-To: <BANLkTikYjD2BnJz99xc-OEntAEJ0gUPztg@mail.gmail.com>
References: <1306999045.29297.55.camel@pasglop>
	<1307003821.29297.77.camel@pasglop>
	<20110602110727.7343782b@lxorguk.ukuu.org.uk>
	<1307062574.29297.204.camel@pasglop>
	<1307081874.23876.14.camel@pasglop>
	<1307084189.23876.19.camel@pasglop>
	<BANLkTim6VsynZHLagcu9Xo3EjsUz=54dYA@mail.gmail.com>
	<BANLkTikJJfyo-eExZYN4iZUO+RrkgPmX4A@mail.gmail.com>
	<BANLkTi=fX8dwfZ53O7E4HX-RsL6bQ=hqWQ@mail.gmail.com>
	<BANLkTikt1ZZNC1YffT_bRAX6GwjWDk_T3Q@mail.gmail.com>
	<BANLkTikYjD2BnJz99xc-OEntAEJ0gUPztg@mail.gmail.com>
Date: Wed, 8 Jun 2011 10:31:55 +0200
Message-ID: <BANLkTin-x1jeR4U_RnfdiE5MASdQTU9ASQ@mail.gmail.com>
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
From: Guillaume Chazarain <guichaz@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, gregkh@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 5:31 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Does this patch fix things for you?

Works perfectly on SMP and UP, thanks!

-- 
Guillaume
