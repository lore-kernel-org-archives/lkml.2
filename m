Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab1IGQXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:23:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab1IGQXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:23:10 -0400
MIME-Version: 1.0
In-Reply-To: <web-602837074@zbackend1.aha.ru>
References: <web-602837074@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 7 Sep 2011 07:45:15 -0700
Message-ID: <CA+55aFzn42Mgt6VRJXyoxTuZBFGff6oG5jvyvOthiQpCq7xPMQ@mail.gmail.com>
Subject: Re: 3.1-rc5 dont boot
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 7, 2011 at 6:28 AM, werner <w.landgraf@ru.ru> wrote:
>
> Now we are at -rc5, but until now, I dont get starting none of the 3.1 -rc 's ,
> so that perhaps it's better to advice about this again as I did before.

So -rc1 doesn't boot either?

Is there any possibility of you bisecting this? That would really
help. It's probably (again) something related to your "almost
everything enabled" config, and without bisecting it's really hard to
even guess where to start...

                          Linus
