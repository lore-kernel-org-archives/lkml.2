Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab2ALHf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 02:35:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47562 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2ALHfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 02:35:54 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzTJe_VwDxiBKyB3dNCJfm=HXxib4Y4fGihhoBFvXiOTw@mail.gmail.com>
References: <20120112065144.GA24051@linux-sh.org> <CA+55aFzTJe_VwDxiBKyB3dNCJfm=HXxib4Y4fGihhoBFvXiOTw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jan 2012 23:35:32 -0800
X-Google-Sender-Auth: pAWdwcIH4JAFVmg0AsFTgVKCrHM
Message-ID: <CA+55aFxjHamzRteKAXLGuBt4LH-ZkJ+PJxZS5kWST-umhK8Zow@mail.gmail.com>
Subject: Re: [GIT PULL] sh updates for 3.3-rc1
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 11:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Looks fine. Except your key isn't actually signed by anybody I
> recognize, so it's kind of worthless that way.

I take that back. I can follow the chain through Magnus Damm to Greg
KH and Rafael Wysocki, I just had to go through that extra step.

Looking good. Pushed out, and if you have current git and want to see
what it all looks like when I pull your signed tag, you can use "git
log --show-signature" to see it revalidate your signature ;)

                   Linus
