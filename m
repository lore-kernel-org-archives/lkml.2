Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2GZVMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:12:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40654 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab2GZVMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:12:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120726071636.GA28129@avionic-0098.mockup.avionic-design.de>
References: <20120726071636.GA28129@avionic-0098.mockup.avionic-design.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 Jul 2012 14:11:58 -0700
X-Google-Sender-Auth: v4-SZpEMqeFS3p3l0pGdwQ5WdaU
Message-ID: <CA+55aFy9JNZyhdTU+btUbBTKsHN1odX1-as=iTC_L9tZr=Oz1w@mail.gmail.com>
Subject: Re: [GIT PULL] PWM subsystem for v3.6
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 12:16 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
>
> The new PWM subsystem aims at collecting all implementations of the
> legacy PWM API and to eventually replace it completely. The subsystem
> has been in development for over half a year now and many drivers have
> already been converted. It has been in linux-next for a couple of weeks
> and there have been no major issues so I think it is ready for inclusion
> in your tree.

For new subsystems like this, I really want ack's from the people who
are expected to use it.

For a gitorious pull like this, I also want signed tags with the gpg
key having signatures from people I recognize. I don't think I have
such a key from you.

              Linus
