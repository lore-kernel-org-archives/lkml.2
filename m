Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045Ab1D0Vnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 17:43:53 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60336 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754601Ab1D0Vnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 17:43:52 -0400
Date: Wed, 27 Apr 2011 22:43:49 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] signal: rename signandsets() to sigandnsets()
Message-ID: <20110427224349.69e5f5f0@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110426195018.GG8520@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
	<20110418173224.GA27918@redhat.com>
	<BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
	<20110423175901.GA484@redhat.com>
	<20110426194822.GA8520@redhat.com>
	<20110426195018.GG8520@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 21:50:18 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> As Tejun and Linus pointed out, "nand" is the wrong name for "x & ~y",
> it should be "andn". Rename signandsets() as suggested.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com> 

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center
