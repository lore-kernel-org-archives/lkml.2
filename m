Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab1HPPHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:07:08 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44014 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1HPPHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:07:05 -0400
Date: Tue, 16 Aug 2011 18:04:52 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] tty: clearify structure initializer in notify_write()
Message-ID: <20110816150452.GL10560@shale.localdomain>
References: <1312027319-1402-1-git-send-email-minipli@googlemail.com>
 <CA+rthh_AW5Yz2ZiOqOTWquXKnsDEd=YcNQ9HiOWu-deSar0eWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rthh_AW5Yz2ZiOqOTWquXKnsDEd=YcNQ9HiOWu-deSar0eWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Jul 30, 2011 at 2:01 PM, Mathias Krause <minipli@googlemail.com> wrote:
> > Even though this is valid C we should not mix C99 initializers with
> > obfuscated ANSI C.

I saw this patch the first time and I couldn't figure out why the
original code was written that way.  I'm curious, is there some trick
here that I don't see, or is it just a typo that happens to work?

regards,
dan carpenter
