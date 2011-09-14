Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab1INUc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:32:57 -0400
Received: from gherkin.frus.com ([192.158.254.49]:56499 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122Ab1INUc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:32:56 -0400
Date: Wed, 14 Sep 2011 15:32:55 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: stupid git question
Message-ID: <20110914203255.GA29723@gherkin.frus.com>
References: <20110914201912.GA29635@gherkin.frus.com> <CA+5PVA7ZZGB5TPFQi4NeN6XQakArOOHrDqoJYVhyOz5ZUEMJwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA7ZZGB5TPFQi4NeN6XQakArOOHrDqoJYVhyOz5ZUEMJwQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 04:22:05PM -0400, Josh Boyer wrote:
> On Wed, Sep 14, 2011 at 4:19 PM, Bob Tracy <rct@gherkin.frus.com> wrote:
> > Pointed "git" at Linus' github.com repository to pull the "-rc6"
> > changes (git pull <repo_url>).  Seems to have worked, except I received
> > no updated tags: the latest tag in my local repo copy is "v3.1-rc4".
> 
> Do a git fetch --tags <repo url> and you'll get the tags too.

Perfect!  Exactly what I needed: thanks!

--Bob
