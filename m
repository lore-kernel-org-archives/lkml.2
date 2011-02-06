Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1BFPEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 10:04:43 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35497 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1BFPEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 10:04:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oIL4x0cL+jloAJ0cJp4heofSL4Xdz4aomTRnhpoNWHmW+KaEaRzuA3Ct16/MULqdxM
         eqXQQqbQ+/ZOUhXbHM0cOAp5XF6DsooAs/h4JtqL9CcUhtUL6d+Ck0nX4u6yx46uevLK
         7u0qnz+J9ZRay4zDuJj9tAoaGCTmoUkjZwjjw=
Subject: Re: [PATCH/RFC v2 1/3] Shared BCH ECC library
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ivan Djelic <ivan.djelic@parrot.com>
Cc: linux-mtd@lists.infradead.org, Tim Barr <tbarr@multitech.com>,
        Sukumar Ghorai <s-ghorai@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <181c9a1c88b781116615761109cccdf89ea877a1.1296641159.git.ivan.djelic@parrot.com>
References: <181c9a1c88b781116615761109cccdf89ea877a1.1296641159.git.ivan.djelic@parrot.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Feb 2011 17:03:47 +0200
Message-ID: <1297004627.4460.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 11:50 +0100, Ivan Djelic wrote:
> Hello,
> 
> This is a repost of my previous patches introducing generic BCH support, with
> a few fixes and an RFC mention that I forgot to put in the first series.
> 
> Comments and suggestions are welcome and appreciated :)

Hi Ivan,

thanks for the library, but could you please re-send it with LKML in CC.

This is not strictly MTD code, you are adding this as a generic library.
So send it to Andrew Morton and CC mtd list and LKML list, ask for
review, wait for comments and then ask Andrew to pick it.

I'm CCing LKML and Andrew Morton.

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

