Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab2FJCSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 22:18:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51207 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2FJCSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 22:18:43 -0400
MIME-Version: 1.0
In-Reply-To: <4FD40035.2020200@spin.net.au>
References: <4FD40035.2020200@spin.net.au>
Date: Sun, 10 Jun 2012 10:18:43 +0800
Message-ID: <CAM_iQpXyMhx5JszEew1O9ehQ0z-eOCZ_DjpdFPNJuKfVafcL3g@mail.gmail.com>
Subject: Re: gcc compiler modification to cater for new programming language
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Chris Jones <chrisjones@spin.net.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 10:02 AM, Chris Jones <chrisjones@spin.net.au> wrote:
> Is it possible to modify the source code of gcc to enable to compilation of
> a completely new programming language, as yet unrecognized? How much of a
> big job would I be looking at for such a task?

Yeah, you need to write a gcc front-end for it.

But this is totally off-topic in LKML, you need to go to gcc mailing list.
