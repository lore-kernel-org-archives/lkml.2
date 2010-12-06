Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0LFQp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:45:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49835 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0LFQpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:45:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=jXxRAhbCUlen1W1Rzaxt+dYa4Us6t/6BUek0AEdk3NQWT01nXQsktxsHB4eaHGJOKX
         /9OQHOIU/aw4ddRkmWWXs3HmPlBi3R9jPcDyBqpLFCKZmr9NTytiNgT6u4p8WNmyCMGs
         367pFAEFkOtcj1zt80QbQei+1EHn+tXkHzIEc=
MIME-Version: 1.0
In-Reply-To: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
References: <AANLkTing7+SK+pavFehR4AGDbRRfFwvvzNxgWQ3zRp+O@mail.gmail.com>
Date: Mon, 6 Dec 2010 17:45:23 +0100
Message-ID: <AANLkTikYF-V2WaEB3a04OhFuzOm2qjx3fWxJ6fOwED5T@mail.gmail.com>
Subject: Re: Atomic non-durable file write API
From: Olaf van der Spek <olafvdspek@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 1:37 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> Hi,
>
> Since the introduction of ext4, some apps/users have had issues with
> file corruption after a system crash. It's not a bug in the FS AFAIK
> and it's not exclusive to ext4.
> Writing a temp file, fsync, rename is often proposed. However, the
> durable aspect of fsync isn't always required and this way has other
> issues.
> What is the recommended way for atomic non-durable (complete) file writes?
>
> I'm also wondering why FSs commit after open/truncate but before
> write/close. AFAIK this isn't necessary and thus suboptimal.

Somebody?
