Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab2JSI2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:28:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62342 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab2JSI2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:28:40 -0400
MIME-Version: 1.0
In-Reply-To: <50810e61.688c320a.1baa.6cacSMTPIN_ADDED@mx.google.com>
References: <1350568765-5723-1-git-send-email-weiyang@linux.vnet.ibm.com>
	<CAFLxGvwfGc_4z1JM=pAb-U4tNVeMZR1zs-neQv7Vz2-6DQT+9Q@mail.gmail.com>
	<1350624189.14741.1.camel@wall-e>
	<5080f0b3.85712b0a.0d0f.ffff9dd2SMTPIN_ADDED@mx.google.com>
	<CAFLxGvxdH=sx9+1y0Uw5gNWL9ZRbPTst3Fj2SgAimoUDbo_2PQ@mail.gmail.com>
	<50810e61.688c320a.1baa.6cacSMTPIN_ADDED@mx.google.com>
Date: Fri, 19 Oct 2012 10:28:38 +0200
Message-ID: <CAFLxGvzRgysSGTibC+EKMZz9RpxSS4twGECp1MAmK1LjXSJwaQ@mail.gmail.com>
Subject: Re: [PATCH] remove untouched code in kfifo_in
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        jkosina@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 10:24 AM, Richard Yang
<weiyang@linux.vnet.ibm.com> wrote:
> got it, thanks~

BTW: The surrounding if (0) {} block could be removed in future.
I'm sure Stefani added it to suppress a compiler warning.
But the typeof() magic has to stay...

-- 
Thanks,
//richard
