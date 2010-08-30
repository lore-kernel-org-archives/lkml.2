Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0H3QMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:12:32 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:48801 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0H3QMb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <4C7BD6CB.2060705@kernel.org>
References: <20100830154825.E4E2560255F@il93ubuntu.localdomain>
	<20100830160147.DE515603843@il93ubuntu.localdomain>
	<4C7BD6CB.2060705@kernel.org>
Date: Mon, 30 Aug 2010 11:12:21 -0500
Message-ID: <AANLkTikMnbGG070khjbKcL93MLsbaQXxvJqh54Jvr5ZL@mail.gmail.com>
Subject: Re: [PATCH v3] scatterlist: prevent invalid free when alloc fails
From: Jeffrey Carlyle <jeff.carlyle@motorola.com>
To: Tejun Heo <tj@kernel.org>
Cc: OLUSANYA SOYANNWO <olusanya.soyannwo@motorola.com>,
        linux-kernel@vger.kernel.org, Hu Tao <taohu@motorola.com>,
        jaxboe@fusionio.com, torvalds@osdl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 11:05 AM, Tejun Heo <tj@kernel.org> wrote:
> On 08/30/2010 05:58 PM, Jeffrey Carlyle wrote:
>> +                     /*
>> +                      * Adjust entry count so that proper free function is
>> +                      * used in sg_kfree.
>> +                      */
>> +                     if(pvr)
>
> I suppose you meant "if (prv)"?

I did. I ran checkpatch.pl and submitted a new patch. Thank you for patience.
