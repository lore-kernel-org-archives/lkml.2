Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab0ELEhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 00:37:48 -0400
Received: from mail.perches.com ([173.55.12.10]:2196 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab0ELEhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 00:37:47 -0400
Subject: Re: [trivial PATCH] arch/x86: Remove unnecessary returns from void
 function()'s
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jiri Kosina <trivial@kernel.org>
In-Reply-To: <4BEA277A.3000505@zytor.com>
References: <1273624747.20514.316.camel@Joe-Laptop.home>
	 <4BE9F94A.9000907@zytor.com>  <1273626052.20514.319.camel@Joe-Laptop.home>
	 <1273629234.20514.333.camel@Joe-Laptop.home>  <4BEA226D.3080103@zytor.com>
	 <1273636283.20514.337.camel@Joe-Laptop.home>  <4BEA277A.3000505@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 21:37:44 -0700
Message-ID: <1273639064.20514.353.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 20:58 -0700, H. Peter Anvin wrote:
> On 05/11/2010 08:51 PM, Joe Perches wrote:
> > On Tue, 2010-05-11 at 20:37 -0700, H. Peter Anvin wrote:
> >> Churn is *not* motivated just
> >> for "consistency" unless it improves readability.
> > Consistency improves readability.
> As a general rule, sure.
> For any specific instance it is a big "it
> depends".

In these specific instances, in my opinion it does.
Your assertion is simply your opinion.
In the end, neither opinion matters much.

cheers, Joe

