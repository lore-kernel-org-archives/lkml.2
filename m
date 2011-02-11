Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab1BKA5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:57:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54812 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab1BKA5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:57:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=J6r9xugSFZwC6S9CprWEkCObeDZ6PU+60XolGpqFYhg4Jb2EKyLFKoJyH9x1mZXPtt
         EZNe+KNdzY6BShXIq8m+tjbns6CZybtsKv/l63vrsutBxSWyc+gRtruZI0bOmcKFpEvw
         fGpEpyYWTDtO4Fnam3TkkmvjTJ56LzZnMwSAE=
MIME-Version: 1.0
In-Reply-To: <20110211004232.GA22440@ghostprotocols.net>
References: <AANLkTi=4_p73eHhQbj5DDDEzTWaLou+u2igiY+yNiPQ9@mail.gmail.com>
	<20110210190843.GE20676@ghostprotocols.net>
	<AANLkTi=WRrBnyiDqOeR7PnqVhh8wLFx5W0tgjNaPvkLg@mail.gmail.com>
	<20110210202023.GG20676@ghostprotocols.net>
	<AANLkTi=H9+rKjgkmfbS2jzfPjryah0cc9sajSgN8WOaQ@mail.gmail.com>
	<20110211004232.GA22440@ghostprotocols.net>
Date: Thu, 10 Feb 2011 16:57:39 -0800
X-Google-Sender-Auth: kvnr66NH58DQN3rPyE_4llqkS_U
Message-ID: <AANLkTimwaOSC9CmO0rCPrRkCac-=Yj2PGg1DE_d0aM55@mail.gmail.com>
Subject: Re: 2.6.37 kernel warning in perf_events code
From: Arun Sharma <arun@sharma-home.net>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 4:42 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Is it possible for you to test this with 2.6.38-rc4? At least the user
> level tools, just do:

I tried the 2.6.38rc3 perf binary on two machines:

kernel = 2.6.37: The machine hung solid on the first try.
kernel = 2.6.38rc3: I could run it 10 times in a loop and no bad runs.

Looks like this is already fixed in newer kernels.

 -Arun
