Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab0LBWGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:06:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:42762 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269Ab0LBWGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:06:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,289,1288594800"; 
   d="scan'208";a="863787403"
Date: Thu, 2 Dec 2010 14:06:50 -0800
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Paul Menage <menage@google.com>
Cc: container cgroup <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC PATCH 1/2] cgroup: add per cgroup timer_slack_ns
Message-ID: <20101202140650.1bc71e53@jacob-laptop>
In-Reply-To: <AANLkTimRrSjJDAxS2Pe5bfMbR=nuV6WQiJdnawSb_kZd@mail.gmail.com>
References: <1291230012-9536-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1291230012-9536-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<AANLkTi=1uv-+Y5t85tyHKk91nJyAKNg5V4Fk2HTJ+ASS@mail.gmail.com>
	<20101202124559.0a7128de@jacob-laptop>
	<AANLkTimRrSjJDAxS2Pe5bfMbR=nuV6WQiJdnawSb_kZd@mail.gmail.com>
Organization: OTC
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010 12:52:36 -0800
Paul Menage <menage@google.com> wrote:

> On Thu, Dec 2, 2010 at 12:45 PM, jacob pan
> <jacob.jun.pan@linux.intel.com> wrote:
> >
> > I guess timer_slack_ns alone cannot qualify for a new subsystem,
> 
> I think that it's providing a sufficiently different control from
> existing subsystems that making it a separate subsystem is reasonable.
> The cpuset subsystem definitely doesn't sound like the right place,
> since it's more dealing with numa isolation/policy. The cpu subsystem
> could be, since it also deals with scheduling stuff.
> 
> Paul
thanks for the pointer. let me try to add a new subsystem. call
it timer? perhaps will have future expansion.
