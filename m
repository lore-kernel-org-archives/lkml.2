Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab0INC2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 22:28:16 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42983 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab0INC2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 22:28:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PK0he7yN5Ump728MR5fN/ybcKwx842SEygpRugXRAjTqpbirntWXCmoiA9SMEgIzAF
         0s4SKiM2nAgON1adK3Ux5dLHUTfgnd8RL3/hA/hbeyinrFCKlFP0r8gtRf+XLhyY0TjV
         N/wF6BDA0s7BrCHe/MVaUazxlB3JofJyR4qis=
MIME-Version: 1.0
In-Reply-To: <20100914021532.9C53E403E6@magilla.sf.frob.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
 <1283442391-23612-15-git-send-email-namhyung@gmail.com> <4C8DCF72.4050701@monstr.eu>
 <AANLkTi=oHVCoeuz20qkBHTUDEwTEDsN4mFdR8nE+CaNk@mail.gmail.com> <20100914021532.9C53E403E6@magilla.sf.frob.com>
From: Namhyung Kim <namhyung@gmail.com>
Date: Tue, 14 Sep 2010 11:27:55 +0900
Message-ID: <AANLkTikWqmxob31RjTxu3zwypxJ29KO=zVEko-157iLB@mail.gmail.com>
Subject: Re: [PATCH v2 14/24] ptrace: cleanup arch_ptrace() on microblaze
To: Roland McGrath <roland@redhat.com>
Cc: monstr@monstr.eu, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 11:15, Roland McGrath <roland@redhat.com> wrote:
> Sorry, I didn't know you had any such expectation.  Oleg and I do not
> autonomously maintain any ptrace tree that gets automatically merged or
> anything like that.  Our Acked-by's are presumed to help your case and our
> objections to hurt it, but you just have to submit patches to linus, akpm,
> arch maintainers, or whatever other channels get merged regularly.  We're
> not that kind of authoritative ourselves, though we are listed as the
> ptrace maintainers.  We have to do the same with our own ptrace patches.
>

Got it. Then I'll submit this to akpm but I think I don't have your
Acked-by yet. :-)
Thanks for the information.

-- 
Regards,
Namhyung Kim
