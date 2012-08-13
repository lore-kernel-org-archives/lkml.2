Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab2HMKBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:01:31 -0400
Received: from canardo.mork.no ([148.122.252.1]:52766 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab2HMKB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:01:29 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Liu Bo <liub.liubo@gmail.com>
Cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG Report] BUG: unable to handle kernel NULL pointer dereference at
Organization: m
References: <5028C4CC.9070301@gmail.com>
Date: Mon, 13 Aug 2012 12:01:24 +0200
In-Reply-To: <5028C4CC.9070301@gmail.com> (Liu Bo's message of "Mon, 13 Aug
	2012 17:11:40 +0800")
Message-ID: <871ujbkt57.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liu Bo <liub.liubo@gmail.com> writes:

> I'm using mainline upstream 3.6.0-rc1 compiled based on Fedora-16.
>
> When I unplug my mobile usb card, I hit this:
>
> [  247.017258] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  247.017378] IP: [<ffffffffa03bf27f>] stop_read_write_urbs+0x3f/0x90 [usb_wwan]

Thanks for reporting.  This should be fixed by

 a1028f0 usb: usb_wwan: replace release and disconnect with a port_remove hook

currently in the usb tree, and hopefully going into the next -rc



Bjørn
