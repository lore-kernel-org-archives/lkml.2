Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab0IMTJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:09:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34773 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab0IMTJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:09:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=SupkDH+4mZ1Jaxam0UVHA0kucV2n6Y/SyC76VqS488UmynYYBxAlzNL3YfehjIMsyk
         K6dOtLcnGmhI3bPtWQUPjDKulmfZosmKSjc+eu698aUhnRk/u8P+Hb5PXOHT7IvSUML2
         4grefXeqoi8gIg78URbefAvseFdZX29C6Je2g=
MIME-Version: 1.0
In-Reply-To: <20100913152138.GA16334@sig21.net>
References: <20100907133429.GB3430@sig21.net> <20100909120044.GA27765@sig21.net>
 <20100910120235.455962c4@schatten.dmk.lab> <20100910160247.GA637@sig21.net> <20100913152138.GA16334@sig21.net>
From: dave b <db.pub.mail@gmail.com>
Date: Tue, 14 Sep 2010 05:09:31 +1000
Message-ID: <AANLkTikoUAgRV18axesaiYnpBWe2V-xhALgh7dtF7p3Y@mail.gmail.com>
Subject: Re: block cache replacement strategy?
To: Johannes Stezenbach <js@sig21.net>
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2010 01:21, Johannes Stezenbach <js@sig21.net> wrote:
> On Fri, Sep 10, 2010 at 06:02:48PM +0200, Johannes Stezenbach wrote:
>>
>> Linear read heuristic might be a good guess, but it would
>> be nice to hear a comment from a vm/fs expert which
>> confirms this works as intended.
>
> Apparently I'm unworthy to get a response from someone knowledgable :-(
>
> Anyway I found lmdd (from lmbench) can do random reads,
> and indeed causes the data to enter the block (page?) cache,
> replacing the previous data.


I am no expert, but what did you think would happen if you did dd
twice from /dev/zero?
but... Honestly what do you think will be cached?
If you want 'COW', use btrfs.

--
Conscience doth make cowards of us all.		-- Shakespeare
