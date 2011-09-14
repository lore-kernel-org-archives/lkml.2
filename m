Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab1INUWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:22:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36214 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164Ab1INUWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:22:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110914201912.GA29635@gherkin.frus.com>
References: <20110914201912.GA29635@gherkin.frus.com>
Date: Wed, 14 Sep 2011 16:22:05 -0400
Message-ID: <CA+5PVA7ZZGB5TPFQi4NeN6XQakArOOHrDqoJYVhyOz5ZUEMJwQ@mail.gmail.com>
Subject: Re: stupid git question
From: Josh Boyer <jwboyer@gmail.com>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 4:19 PM, Bob Tracy <rct@gherkin.frus.com> wrote:
> Subject says a mouthful, but I digress...
>
> Pointed "git" at Linus' github.com repository to pull the "-rc6"
> changes (git pull <repo_url>).  Seems to have worked, except I received
> no updated tags: the latest tag in my local repo copy is "v3.1-rc4".
>
> Is this an expected consequence of doing the initial clone operation
> from one repo, and then pulling updates from another that, in theory, is
> identical to the first?  If so, is there an officially sanctioned method
> of switching repositories that doesn't require blowing away the local
> copy and doing another "git clone"?

Do a git fetch --tags <repo url> and you'll get the tags too.

josh
