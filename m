Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0JGUnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:43:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64105 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab0JGUnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=qZkW8MkUdX85HjqN+bdzjLt0OJ+YrvsVsgjrmvYA1mu/rdNk0P0BGmtFo/wnk1HVfC
         h9zUhnf8uDKeqaqtnhV8T15J47DEIExRCNIWUQCbbnzVAme3CFJ3mscs4S9YdRWQgoyf
         5gXTtQS04+fYWWrmU5O2SKbT5J89Yj1PZWbg8=
MIME-Version: 1.0
In-Reply-To: <20101007130904.29350df2@debxo>
References: <20101007185952.A36859D401B@zog.reactivated.net>
	<20101007130904.29350df2@debxo>
Date: Thu, 7 Oct 2010 21:42:59 +0100
X-Google-Sender-Auth: FC0t728CTzEZs7GWtm8caeMGanM
Message-ID: <AANLkTind-S=vzba56DmkzR2BixLGUyBTqu4rgaMcSf5w@mail.gmail.com>
Subject: Re: [PATCH] OLPC: Add XO-1 poweroff support
From: Daniel Drake <dsd@laptop.org>
To: Andres Salomon <dilinger@queued.net>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 October 2010 21:09, Andres Salomon <dilinger@queued.net> wrote:
> Any particular reason why this can't be modular?

Because of the pm_power_off thing.
Also, a similar situation would be encountered with set_suspend_ops().

I don't really understand your suggestion. If we set it to NULL on
module unload then the power off would crash on shutdown, right?

Daniel
