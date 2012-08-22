Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab2HVCkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 22:40:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57855 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2HVCkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 22:40:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120821133455.9090.24759.stgit@localhost.localdomain>
References: <20120821133455.9090.24759.stgit@localhost.localdomain>
Date: Wed, 22 Aug 2012 10:40:20 +0800
Message-ID: <CAMiH66ELxva10BOy2nYxT31kOeuxffX4rbUb-XGmE2efJtqcmw@mail.gmail.com>
Subject: Re: [PATCH] tty: move the async flags from the serial code into the
 tty includes
From: Huang Shijie <shijie8@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 9:35 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> Huang - how about we add this patch first which moves the flags somewhere more sensible
> and then your helper function (and probably a few others) would merge cleanly ?
>
Allen, Could you post a formal patch?
I can change my patch based on it.

thanks
Huang Shijie
