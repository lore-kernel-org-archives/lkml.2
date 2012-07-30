Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2G3PCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:02:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46182 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab2G3PCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:02:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAECXXi5OjRwQ3Ma2k+XGwGWf8E-CMhYsFERxtoSkEjmTktnsfQ@mail.gmail.com>
References: <1338992116-28094-1-git-send-email-loke.chetan@gmail.com>
	<CAECXXi5OjRwQ3Ma2k+XGwGWf8E-CMhYsFERxtoSkEjmTktnsfQ@mail.gmail.com>
Date: Mon, 30 Jul 2012 11:02:22 -0400
Message-ID: <CAAsGZS4M1ZgWyFAmVm26JO7VRrfc0ociY3Z_PDPvHrdbdFT7-w@mail.gmail.com>
Subject: Re: [PATCH 1/1] block/nbd: micro-optimization in nbd request completion
From: chetan loke <loke.chetan@gmail.com>
To: paul.clements@us.sios.com
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 1:20 PM, Paul Clements
<paul.clements@steeleye.com> wrote:
> Makes sense. Looks good to me.
>
> Acked-by: Paul.Clements@steeleye.com
>
> On Wed, Jun 6, 2012 at 10:15 AM, Chetan Loke <loke.chetan@gmail.com> wrote:
>>
>> Add in-flight cmds to the tail. That way while searching(during request completion),we will always get a hit on the first element.
>>

Paul/Jens,

Looks like this one isn't merged yet.

Chetan Loke
