Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1AaS1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:27:10 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36080 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab1AaS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:27:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fA3YLQvxbqnoyiT7c4WwDuRM1W1ybPbSaEQe1BaUkLwuUYlrkDbsUeRSUr5QAGCHtQ
         z3brUwCOW1GJ+dsi3VRIBUgmHJlC5k0j7yf0ZySg0lt+R2hKhI4xLK9B/jnX0WN3JL2j
         8deo9uT5o3nB8uOFbnCryNmg/s1DmlMXcuFVw=
Date: Mon, 31 Jan 2011 21:27:04 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: Fwd: [PATCH] bq27x00_battery: Some fixes
Message-ID: <20110131182704.GA13244@oksana.dev.rtsoft.ru>
References: <20110131135417.GC3883@oksana.dev.rtsoft.ru>
 <4D46FC2A.6010402@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4D46FC2A.6010402@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 07:15:06PM +0100, Lars-Peter Clausen wrote:
> On 01/31/2011 02:54 PM, Anton Vorontsov wrote:
> > The same is for this patch.
> > 
> > Comments, Reviewed-by or Acked-by?
> > 
> > p.s. FWIW, I already asked Pali to factor out bq27x00_battery_time()
> >      fix to a separate patch.
> > 
> 
> Hi
> 
> I have a larger series pending which adds support for the bq27000 chip and polling to
> the bq27x00 driver. Since this series does some refactoring of the bq27x00 driver, it
> might make sense to rebase this (and the other) patch ontop of that series instead of
> the other way around.

Pali was first to send out his work, so I think that it would make
sense to ask you to rebase your work on top. Especially since Pali's
patches were somewhat reviewed already.

I hope Pali will resend the fixed versions quickly enough so
that I'll apply the patches asap and you'll easily use git
for rebasing.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
