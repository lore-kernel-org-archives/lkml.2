Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab1FRI6x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 04:58:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60564 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1FRI6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 04:58:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=nRQhYmy5M+wfVJKj9NTy+ez0UbF2cyw5XwzySLoZkR+zUaqCi5QSbZ4D9K2YAD8488
         +ahpn0gqcw5jCBtj0mYIDyjnekMS5fv9beZnEuo/UkOhvJhoCYlpDO1Jk5DOUWW1fGCp
         PSzrGN2u57A/d+c1Fxh79V74itNXSdl/aWX34=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/5] ptrace: implement PTRACE_SEIZE
Date: Sat, 18 Jun 2011 10:58:48 +0200
User-Agent: KMail/1.8.2
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com, pedro@codesourcery.com
References: <1308043218-23619-1-git-send-email-tj@kernel.org> <201106180955.37531.vda.linux@googlemail.com> <20110618083032.GJ2611@htj.dyndns.org>
In-Reply-To: <20110618083032.GJ2611@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106181058.48744.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 10:30, Tejun Heo wrote:
> > I propose to define PTRACE_EVENT_STOP as 64 instead, leaving 64 low
> > PTRACE_EVENT_foo constants for possible future PTRACE_O_foo bits.
> > 
> > [32 should be enough too, but I feel paranoid today :)]
> 
> But this might not be a bad idea.  Given that we also support 32bit
> archs, going over 32 wouldn't help much tho.

In 2030, 32 bit will be sort of like 16 bit today :)
and we'll suddenly find it not impossible to use bit positions >= 32.

(and I will be so old it's not funny)

-- 
vda
