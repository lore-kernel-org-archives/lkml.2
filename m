Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1BBUIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:08:38 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61895 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1BBUIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 15:08:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=EXLIT8/InUj+eESyGkIgaWycEeKClUB40F/cX3EFUQwXDWE5imBThJpVLRTlSCmta0
         +m9vxI94VExK20+JHhHMJ+robfDYNyQwe2WkM6ORHEqmDPQW1OX7o9RVYaI/MvrkAQGb
         KXYFreBJXrShMjxCI04rYTO+4896DnJD9rHYQ=
MIME-Version: 1.0
In-Reply-To: <20110202113342.3775c997.akpm@linux-foundation.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-3-git-send-email-tj@kernel.org>
	<20110128184601.CBF7C180996@magilla.sf.frob.com>
	<20110131103855.GD7459@htj.dyndns.org>
	<20110201102618.GE14211@htj.dyndns.org>
	<20110201162729.f75be47d.akpm@linux-foundation.org>
	<20110202053331.C27C6183D88@magilla.sf.frob.com>
	<20110201213828.c3df7e87.akpm@linux-foundation.org>
	<20110202103402.GB24115@htj.dyndns.org>
	<20110202113342.3775c997.akpm@linux-foundation.org>
Date: Wed, 2 Feb 2011 21:01:40 +0100
X-Google-Sender-Auth: Y1sfXtZkN_4ncZwah49ManKHl0Y
Message-ID: <AANLkTinm5zYQrXNPmXcf88uRs7Am2eV6u6+h6cnYgSY6@mail.gmail.com>
Subject: Re: [PATCH] ptrace: use safer wake up on ptrace_detach()
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 2, 2011 at 8:33 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> We're learning some lessons about changelogging here :(
>
> I added this:

I was aiming for being a bit less explicit, which may or may not have
been a good idea.  Anyways, sounds good to me.

Thanks.

-- 
tejun
