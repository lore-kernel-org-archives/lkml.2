Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3AHGpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 01:45:52 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:55951 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3AHGpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 01:45:49 -0500
Date: Tue, 8 Jan 2013 10:38:59 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, James Morris <jmorris@namei.org>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
Message-ID: <20130108063859.GB4537@cachalot>
References: <50EB7C50.3070605@schaufler-ca.com>
 <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au>
 <50EB9A5E.1080306@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EB9A5E.1080306@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 20:02 -0800, Casey Schaufler wrote:
> On 1/7/2013 7:01 PM, Stephen Rothwell wrote:
> > Let me ask Andrew's question:  Why do you want to do this (what is the
> > use case)?  What does this gain us?
> 
> There has been an amazing amount of development in system security
> over the past three years. Almost none of it has been in the kernel.
> One important reason that it is not getting done in the kernel is
> that the current single LSM restriction requires an all or nothing
> approach to security. Either you address all your needs with a single
> LSM or you have to go with a user space solution, in which case you
> may as well do everything in user space.
[...]

You should also update Documentation/security/LSM.txt with new "security="
rules and rules of LSM stacking limitations.  Motivation of stacking is
probably worth noting in Documentation/ too.

Thanks,

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
