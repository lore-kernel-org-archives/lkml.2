Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2FNRbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:31:23 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:15737 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab2FNRbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:31:22 -0400
Message-ID: <1339695079.2603.19.camel@lorien2>
Subject: Re: [PATCH] x86: kernel/cpu/mtrr/cleanup.c simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Ingo Molnar <mingo@kernel.org>
Cc: shuahkhan@gmail.com, tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 14 Jun 2012 11:31:19 -0600
In-Reply-To: <20120614104819.GA8683@gmail.com>
References: <1339612907.13326.5.camel@lorien2>
	 <20120614104819.GA8683@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 12:48 +0200, Ingo Molnar wrote:
> * Shuah Khan <shuahkhan@gmail.com> wrote:
> 
> > Change parse_mtrr_spare_reg() to call kstrtoul() instead of calling obsoleted
> > simple_strtoul().
> > 
> > Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> > ---
> >  arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> There's about 22 simple_strto*() uses remaining in arch/x86/ - 
> please send a single patch that addresses them in one go, 
> instead of these peacemail patches...
> 
Since I use my personal spare time doing this type of work it is easier
for me to work on one patch at a time, however I understand it will be
easier for you to pull in a single large patch as opposed to multiple. I
will pool my changes and send them in a single patch.

-- Shuah

