Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761175Ab0HFKVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:21:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64951 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761118Ab0HFKVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=dBMbUqLCXNJedcO8+fHjfGyUOqZ7HZYCVP2xFPbULYaXyd+XIJpNMjRg0XPTJJY3Vj
         NOcCwNTD7IKAOb5eyq+hKz/Ud710Bb886Wq7f+AJnZ/cK3pfZF7lZi3hq+Yeu7y4MM2g
         KFjbMXYPycrgCq2fJqBp3OoHfwDtWyE870Ifk=
Date: Fri, 6 Aug 2010 12:21:25 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Trivial. Fix typo in kconfig entry.
Message-ID: <20100806122125.3e1768cf@varda>
In-Reply-To: <20100806014328.GA22465@gondor.apana.org.au>
References: <20100805112142.68d8926d@varda>
	<20100806014328.GA22465@gondor.apana.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 6 Aug 2010 09:43:28 +0800
Herbert Xu <herbert@gondor.apana.org.au> escribió:

> On Thu, Aug 05, 2010 at 11:21:42AM +0200, Alejandro Riveira Fernández wrote:
> > 
> >  This fixes a typo in file crypto/Kconfig.
> 
> Thanks for the patch.  As I've just negated this option, the typo
> text no longer exists in the crypto-2.6 tree.

 Fair enough.

> 
> Cheers,
