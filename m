Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1GUSSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:18:02 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62553 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1GUSR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:17:58 -0400
MIME-Version: 1.0
In-Reply-To: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
Date: Thu, 21 Jul 2011 13:17:58 -0500
Message-ID: <CADzpL0Tfng4=k4wnewi=N2tVQdi5-9PXBcrzCL0sAONF+fdmEQ@mail.gmail.com>
Subject: Re: [PATCH] hpsa: do not attempt to read from a write-only register
From: Stephen Cameron <stephenmcameron@gmail.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 1:16 PM, Stephen M. Cameron
<scameron@beardog.cce.hp.com> wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> Most smartarrays tolerate it, but a few new ones don't.
> Without this change some newer Smart Arrays will lock up
> and i/o will grind to a halt.


Noticed this wasn't in Linus's git tree yet, so resent it.

-- steve
