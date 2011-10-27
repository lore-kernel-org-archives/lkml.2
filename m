Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab1J0M4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:56:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64590 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1J0M4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:56:18 -0400
Date: Thu, 27 Oct 2011 15:53:48 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eventpoll: possible recursive locking detected
Message-ID: <20111027125347.GA3373@swordfish>
References: <20111027121432.GA3039@swordfish>
 <CA+5PVA51Rdd-33v-2pxdzXpQGnMrL+PYkzeXqM1R2fxXCK=Bqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA51Rdd-33v-2pxdzXpQGnMrL+PYkzeXqM1R2fxXCK=Bqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/27/11 08:46), Josh Boyer wrote:
> Nelson Elhage posted a patch to fix this for the 3.1 merge window and
> it never went in.  You can find it here:
> 
> http://thread.gmane.org/gmane.linux.kernel/1177210
> 
> Not sure why it hasn't been pushed upstream yet.
> 

Oh, good, thanks for pointing out.

	Sergey
