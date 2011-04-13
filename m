Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1DMRwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:52:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60489 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1DMRwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uJ8jVwRZ+hsPjyKbPoXoG9T/hM7pXidS5rmbHxHeXkqMWFrHsJSQFxtsssk4MYGuLU
         vZ2J81AVQz20q1EwLZbzLHqhMUnzZ03k0XolM73uXxjDBNnCDLKeoYGqWU/4aM5vDzKp
         7LjOrlLTuDdFLurqzX60PUuH/Hm2zG4IE5B8g=
MIME-Version: 1.0
In-Reply-To: <1302685102.28876.81.camel@pasglop>
References: <19876.35918.322649.256455@pilspetsen.it.uu.se>
	<1302646173.28876.53.camel@pasglop>
	<1302652502.28876.76.camel@pasglop>
	<19877.23529.745123.819112@pilspetsen.it.uu.se>
	<1302685102.28876.81.camel@pasglop>
Date: Wed, 13 Apr 2011 12:52:11 -0500
Message-ID: <BANLkTimc84A8kddarnhvrcab3iKZc0HZAg@mail.gmail.com>
Subject: Re: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
From: kevin diggs <diggskevin38@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

On Wed, Apr 13, 2011 at 3:58 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> Actually I do get a crash in X later on... something in the radeon DRM
> interrupt code is getting what looks like a NULL dereference. I'll try
> to dig that one later on. I don't know if it's related to your problem
> at all though.
>
In this context, what does 'crash' mean? The X thingy goes down? Or
the whole OS?

Cheers,
kevin.

> Cheers,
> Ben.
