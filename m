Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab1KCOo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:44:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52762 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab1KCOoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <20111103073725.GA7319@elte.hu>
References: <20111102134900.GB4377@one.firstfloor.org> <CA+55aFwCf41GFOVA656-ZgZB5mBNkpH3KqRfJ_Ornkn3RWF5gQ@mail.gmail.com>
 <20111103073725.GA7319@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Nov 2011 07:44:33 -0700
X-Google-Sender-Auth: F1jXUYpF0cFxls39_ExWzDlXIVM
Message-ID: <CA+55aFx4sCCyN77v90-a2UW9SQ9FzE-17J-nK9kDBTm0MFsQ3Q@mail.gmail.com>
Subject: Re: REGRESSION: "perf: Add PM notifiers ..." breaks resume
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, rjw@sisk.pl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 12:37 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Yep, please revert it until we do the right fix. (I can queue up the
> revert too)

Reverted,

                Linus
