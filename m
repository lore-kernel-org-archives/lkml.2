Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1ERVoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:44:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14318 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab1ERVoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:44:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dfrbD6gm/xozLHNI1JfYlCTC1Fc7iJOPFYL7xUkb/0eGfUe7dbfB+jala/BtVEgZKw
         /MM0oXUqh4k/vkbEPzsA==
MIME-Version: 1.0
In-Reply-To: <20110518.171603.2048423328863525352.davem@davemloft.net>
References: <1305753000-14933-1-git-send-email-decot@google.com>
 <1305753000-14933-2-git-send-email-decot@google.com> <20110518.171603.2048423328863525352.davem@davemloft.net>
From: David Decotigny <decot@google.com>
Date: Wed, 18 May 2011 14:43:58 -0700
Message-ID: <BANLkTinG4K-bWS1qqBr_G9mK5OHDYknszg@mail.gmail.com>
Subject: Re: [PATCH 2/2] forcedeth: allow to silence tx_timeout debug messages
To: David Miller <davem@davemloft.net>
Cc: Joe Perches <joe@perches.com>, szymon@janc.net.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-net-upstream@google.com,
        Sameer Nanda <snanda@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

No problem, I will send the patch series correctly numbered. Sorry for that.

Regarding your comment about this debug info change:

On Wed, May 18, 2011 at 2:16 PM, David Miller <davem@davemloft.net> wrote:
> You can add a knob which when enabled gives the old verbosity
> back for diagnostic purposes.

That was the intent of this patch: it adds a debug_tx_timeout module
parameter to act as the knob. I can rephrase the description of the
patch, it didn't make this so clear.
Or are you suggesting I should implement this with another kind of knob?

Thanks!
