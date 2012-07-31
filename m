Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2GaGsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:48:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33936 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab2GaGsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:48:05 -0400
Message-ID: <50177F96.4040007@kernel.dk>
Date: Tue, 31 Jul 2012 08:47:50 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: chetan loke <loke.chetan@gmail.com>
CC: paul.clements@us.sios.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] block/nbd: micro-optimization in nbd request completion
References: <1338992116-28094-1-git-send-email-loke.chetan@gmail.com> <CAECXXi5OjRwQ3Ma2k+XGwGWf8E-CMhYsFERxtoSkEjmTktnsfQ@mail.gmail.com> <CAAsGZS4M1ZgWyFAmVm26JO7VRrfc0ociY3Z_PDPvHrdbdFT7-w@mail.gmail.com>
In-Reply-To: <CAAsGZS4M1ZgWyFAmVm26JO7VRrfc0ociY3Z_PDPvHrdbdFT7-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 05:02 PM, chetan loke wrote:
> On Wed, Jun 6, 2012 at 1:20 PM, Paul Clements
> <paul.clements@steeleye.com> wrote:
>> Makes sense. Looks good to me.
>>
>> Acked-by: Paul.Clements@steeleye.com
>>
>> On Wed, Jun 6, 2012 at 10:15 AM, Chetan Loke <loke.chetan@gmail.com> wrote:
>>>
>>> Add in-flight cmds to the tail. That way while searching(during request completion),we will always get a hit on the first element.
>>>
> 
> Paul/Jens,
> 
> Looks like this one isn't merged yet.

I've merged it now.

-- 
Jens Axboe

