Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030309Ab2EQQxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:53:42 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41676 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030277Ab2EQQxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:53:38 -0400
MIME-Version: 1.0
In-Reply-To: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 May 2012 09:53:16 -0700
X-Google-Sender-Auth: JqOcBowT6vmi-WbAvhAfj1bCRAg
Message-ID: <CA+55aFxRjxf_3hka_SSqC+p32aDMU=0rq0_RaceO=bQqmtO2xg@mail.gmail.com>
Subject: Re: [RFC/PATCH 0/5] Delete microchannel [CONFIG_MCA] support
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 9:40 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> It was good that we could support MCA machines back in the day, but
> realistically, nobody is using them anymore.

Yeah, I think I can ack this. Looks like 3.5 will be a nice "remove
stupid hardware support" release.

Maybe we could some day remove EISA support too..

                      Linus
