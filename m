Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1ERVUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:20:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55413 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab1ERVUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=sO7CHbJMshh6Uq6leDTKECFVQrG5RWJ98Y59qQ3nTXuVEa6wQp0MA77ph5gsp9xft+
         SE49tWwFqRCN5Dj03neQ==
MIME-Version: 1.0
In-Reply-To: <20110518.171416.1780927258138770742.davem@davemloft.net>
References: <1305752945-14843-1-git-send-email-decot@google.com>
 <1305752945-14843-2-git-send-email-decot@google.com> <20110518.171416.1780927258138770742.davem@davemloft.net>
From: David Decotigny <decot@google.com>
Date: Wed, 18 May 2011 14:20:21 -0700
Message-ID: <BANLkTimNvuB5HtOKfAc7rf5wF2QeC3xdXw@mail.gmail.com>
Subject: Re: [PATCH] forcedeth: new ethtool stat "tx_timeout" to account for tx_timeouts
To: David Miller <davem@davemloft.net>
Cc: Joe Perches <joe@perches.com>, szymon@janc.net.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-net-upstream@google.com,
        snanda@google.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

They should be independent and applicable in any order, except for the
two 'PATCH x/2' which have to go together.

FYI, here is the order in which I'm applying them:
1/ forcedeth: Improve stats counters
2/ forcedeth: new ethtool stat "tx_timeout" to account for tx_timeouts
3/ [PATCH 1/2] forcedeth: make module parameters readable in /sys/module
4/ [PATCH 2/2] forcedeth: allow to silence tx_timeout debug messages
5/ forcedeth: Acknowledge only interrupts that are being processed
6/ forcedeth: Add messages to indicate using MSI or MSI-X
7/ forcedeth: Fix a race during rmmod of forcedeth

Sorry for that.
Regards,

--
David Decotigny



On Wed, May 18, 2011 at 2:14 PM, David Miller <davem@davemloft.net> wrote:
>
> When submitting multiple patches in a patch set, NUMBER THEM.
>
> Otherwise there is no unambiguous way to figure out what order
> I should apply these patches.
>
