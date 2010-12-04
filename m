Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab0LDFlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 00:41:24 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:52304 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0LDFlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 00:41:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Nw5ZKYcAY1WwGSHML75W/k2IkvfHOKFV39itiGWQ9haiX9nSuJMK85whG8cCc9D1YC
         U3Cb6LOBj3z0RTdUE9cn+f0Hc7e0+GO0CcU+gzdCjIGWKl4Hgey4a6r25acyiPsy6wiy
         XRKmyWLU+0647NBWXF4sbAUq6CwK/C03va6cU=
MIME-Version: 1.0
In-Reply-To: <4CECAFD1.10506@gmail.com>
References: <20101121140808.GA6429@moria>
	<AANLkTim7_Lm3U+jHe7KG8Ha9rqe=jg2yffb8NA8RLiGM@mail.gmail.com>
	<4CECAFD1.10506@gmail.com>
Date: Sat, 4 Dec 2010 00:41:20 -0500
Message-ID: <AANLkTikHhkK8WaFxOL+HkaCY97PCvFfON8cQV0xU_-0u@mail.gmail.com>
Subject: Re: Bcache version 9
From: John Drescher <drescherjm@gmail.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: =?ISO-8859-1?Q?C=E9dric_Villemain?= 
	<cedric.villemain.debian@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Is it its main diff with flashcache ?
>> https://github.com/facebook/flashcache/blob/master/doc/flashcache-doc.txt
>
> Yeah. It's a more complex approach, but it's capable of significantly higher
> performance. Performance has regressed some lately (I've been concentrating
> on other things and don't really have the hardware for performance work),
> but a month or so ago it was benchmarking around 50% higher than flashcache,
> with mysql on an X25-E.

BTW, Thanks for releasing this..
I am just in the middle of evaluating using flashcache to speed up
slow IO in kvm clients when storing the VMs on hard disks. I will when
I get a chance try your patch..

John
