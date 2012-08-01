Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2HABIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 21:08:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44737 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2HABIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 21:08:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120731081945.GB14593@avionic-0098.adnet.avionic-design.de>
References: <20120726071636.GA28129@avionic-0098.mockup.avionic-design.de>
 <CA+55aFy9JNZyhdTU+btUbBTKsHN1odX1-as=iTC_L9tZr=Oz1w@mail.gmail.com> <20120731081945.GB14593@avionic-0098.adnet.avionic-design.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 31 Jul 2012 18:08:01 -0700
X-Google-Sender-Auth: a7gNHAP236eohpLYiboFxjDgosY
Message-ID: <CA+55aFx=m=+7QTBKH3_bBzustGRePy0XrykE3ZVzFi5wyG6rQg@mail.gmail.com>
Subject: Re: [GIT PULL] PWM subsystem for v3.6
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 1:19 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
>
> I just sent a new pull request with a signed tag. I've also included a
> more detailed description of why this is useful, along the lines of what
> Arnd already mentioned.
>
> My key was signed by Sebastian Andrzej Siewior today and I uploaded the
> signature only now, so it may take some time to propagate.

Ok. I had decided that I had lots of acks for your code and had
actually pulled your code yesterday, so my merge doesn't have that new
tag information. But I verified your tag separately, and everything
looks fine. So future pulls will then be properly signed in my repo
too if you use tags,

            Linus
