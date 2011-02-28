Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1B1Une (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:43:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37445 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab1B1Und (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:43:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Several riskless, tiny fixes
Date: Mon, 28 Feb 2011 21:43:21 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Thomas Renninger <trenn@suse.de>, lenb@kernel.org,
        linux-kernel@vger.kernel.org
References: <1298842606-55712-1-git-send-email-trenn@suse.de> <20110228075459.GA1600@elte.hu>
In-Reply-To: <20110228075459.GA1600@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102282143.21732.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 28, 2011, Ingo Molnar wrote:
> 
> * Thomas Renninger <trenn@suse.de> wrote:
> 
> > Some of these could still get pushed into 2.6.38?
> > 
> > If not, it would be great if they get queued in:
> >  - x86-tip tree, the two perf patches and the pm_qos patch
> 
> I suspect the pm_qos patch should be processed by the PM tree - Rafael?

That's correct, thanks!

Rafael
