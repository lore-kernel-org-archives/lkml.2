Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0FIIDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 04:03:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63507 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab0FIIC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 04:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=u/XF2SsGJaftTffpLqHLPMmO7rnB8upZMpNDa8J+HKOAjpbcnSl7gOajStBxYaQCUL
         V/HMXQmrSjwxQyUPChwtysunX+bbL+pUXsqDsytkmaduNEfZY3Dc78sbcgj5BRNB98TX
         3HdcQ3SXU5FqC9sgmIJsf/jtQ/XL1dUyCzSxs=
MIME-Version: 1.0
In-Reply-To: <20100609071623.GC20057@colossus>
References: <20100609071623.GC20057@colossus>
Date: Wed, 9 Jun 2010 11:02:55 +0300
X-Google-Sender-Auth: _34H4vMkwJNWUKRpO5BgVk37MoA
Message-ID: <AANLkTin_EvlveCvbCZ0vH54UEP479ufQ-irFqXSOnT0R@mail.gmail.com>
Subject: Re: [stable] Please apply ucc_geth patches to 2.6.32-stable
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Petri Lehtinen <petri.lehtinen@inoi.fi>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, avorontsov@ru.mvista.com,
       Linux Netdev List <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 10:16 AM, Petri Lehtinen <petri.lehtinen@inoi.fi> wrote:
> The following three patches fix some serious flaws in the ucc_geth
> network driver in 2.6.32. From oldest to newest:
>
> 7583605b6d29f1f7f6fc505b883328089f3485ad ucc_geth: Fix empty TX queue processing
> 08b5e1c91ce95793c59a59529a362a1bcc81faae ucc_geth: Fix netdev watchdog triggering on link changes
> 34692421bc7d6145ef383b014860f4fde10b7505 ucc_geth: Fix full TX queue processing
>
> They apply cleanly on top of 2.6.32-stable master. They were also
> originally Cc'd to be included in 2.6.32-stable.

You forgot to CC stable@kernel.org, netdev, and the original author of
those patches.
