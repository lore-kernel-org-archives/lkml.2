Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab2EYLNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:13:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44696 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2EYLNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120525111152.7239.99793.stgit@bob.linux.org.uk>
References: <20120525111152.7239.99793.stgit@bob.linux.org.uk>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 25 May 2012 13:13:15 +0200
Message-ID: <CA+1xoqcwM7j3K_UNKNcHOQKthi3N8r5FJtc-XsXK-BOcKE3Lmw@mail.gmail.com>
Subject: Re: [PATCH] tty: remove recursive implementation of tty_ldisc_release
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 1:11 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> From: Alan Cox <alan@linux.intel.com>
>
> We need to do this in one pass with the locking requirements we now
> have.
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---

I don't see any lockdep warnings anymore with this patch applied on
top of all others.
