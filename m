Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab0HMBhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 21:37:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36925 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0HMBhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 21:37:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Helsley <matthltc@us.ibm.com>,
        Tomasz Buchert <Tomasz.Buchert@inria.fr>
Subject: Re: [PATCH] cgroup_freezer: Freezing and task move race fix
Date: Fri, 13 Aug 2010 03:35:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr> <4C6252CF.1090100@inria.fr> <20100812002154.GJ2927@count0.beaverton.ibm.com>
In-Reply-To: <20100812002154.GJ2927@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008130335.55641.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 12, 2010, Matt Helsley wrote:
> On Wed, Aug 11, 2010 at 09:35:43AM +0200, Tomasz Buchert wrote:
> > Matt Helsley a écrit :
...
> You're right, cgroup_mutex should protect against that. However presumably
> that same logic applies to the first case. So again I don't think the bug
> is a race.
> 
> <snipped the remaining cases which should be the same>
> 
> At this point I think the bug description in your patch needs to change
> but the patch itself is perfect. Assuming you agree with my assessment
> of the bug I think the process is: you'll rewrite the description, add -stable
> maintaners to your current Cc's (since this bug is simple, exists in previous
> versions, and is somewhat nasty), add:
> 
> Reviewed-by: Matt Helsley <matthltc@us.ibm.com>
> Tested-by: Matt Helsley <matthltc@us.ibm.com>
> 
> and send it to Andrew Morton. Hopefully then (if not before) Paul and Li
> will ack it.

Actaully, I maintain the freezer, so please send it to me.

Thanks,
Rafael
