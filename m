Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1EPMYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:24:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38750 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1EPMYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q+GeAFHFrpjuKIcSfckeF+9rawE3NZxMhL3PSg21KSSrlIY+ZAHoMCcbP7b7BGz+Ky
         +XvsXpfmql3Hf5NlOQI61MlowcPAqCZ/B674A+OV3A5QOyvO0JH+lE2lo6so5h3lQuDh
         5DsiIdzkD8qqAxzmSdMZi0YwdisPbz1frUoRA=
Date: Mon, 16 May 2011 14:24:14 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_DETACH without stop  [Re: [PATCH 04/11] ptrace:
 implement PTRACE_INTERRUPT]
Message-ID: <20110516122414.GS23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <20110510095022.GR1661@htj.dyndns.org>
 <20110510140620.GB21834@redhat.com>
 <201105102359.58900.vda.linux@googlemail.com>
 <20110511091955.GD1661@htj.dyndns.org>
 <20110515161000.GE31855@host1.jankratochvil.net>
 <20110515163523.GH23665@htj.dyndns.org>
 <20110515173940.GA26241@host1.jankratochvil.net>
 <20110516090125.GP23665@htj.dyndns.org>
 <20110516120822.GA10469@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516120822.GA10469@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 02:08:22PM +0200, Jan Kratochvil wrote:
> > Nope.  What userland is currently dealing with isn't that type of
> > conditions.  It's dealing with nasty side effects of implied and
> > required signals, which will be removed with the new interface.
> 
> They won't as there will be new INTERRUPT event and when one wants to trap it
> one has to deal with various signals coming before or after it.

I'd rather lean toward handling it properly from userland.  Strictly
defining trap order is too fragile.  I think the right thing to do
here is properly documenting how to recognize and handle different
types of traps.

Thanks.

-- 
tejun
