Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab1J0Mqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:46:42 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33907 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab1J0Mql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:46:41 -0400
MIME-Version: 1.0
In-Reply-To: <20111027121432.GA3039@swordfish>
References: <20111027121432.GA3039@swordfish>
Date: Thu, 27 Oct 2011 08:46:40 -0400
Message-ID: <CA+5PVA51Rdd-33v-2pxdzXpQGnMrL+PYkzeXqM1R2fxXCK=Bqg@mail.gmail.com>
Subject: Re: [PATCH] eventpoll: possible recursive locking detected
From: Josh Boyer <jwboyer@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 8:14 AM, Sergey Senozhatsky
<sergey.senozhatsky@gmail.com> wrote:
> Hello,
> Hit this lockdep warning today (with 3.2-merge-window kernel). Below is my
> naive approach.

Nelson Elhage posted a patch to fix this for the 3.1 merge window and
it never went in.  You can find it here:

http://thread.gmane.org/gmane.linux.kernel/1177210

Not sure why it hasn't been pushed upstream yet.

josh
