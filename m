Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1KZNVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 08:21:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37786 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab1KZNVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 08:21:45 -0500
MIME-Version: 1.0
In-Reply-To: <1322184806-20421-4-git-send-email-glommer@parallels.com>
References: <1322184806-20421-1-git-send-email-glommer@parallels.com> <1322184806-20421-4-git-send-email-glommer@parallels.com>
From: Paul Turner <pjt@google.com>
Date: Sat, 26 Nov 2011 05:21:13 -0800
Message-ID: <CAPM31RJoN2t+nUuap+FWLYoEx=EshU=v6Gy8JsxJAaichZFjcA@mail.gmail.com>
Subject: Re: [PATCH 3/4] Move part of cpuacct code
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        a.p.zijlstra@chello.nl, jbottomley@parallels.com,
        cgroups@vger.kernel.org, devel@openvz.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 5:33 PM, Glauber Costa <glommer@parallels.com> wrote:
> This patch is just a preparation patch for the next one in the series.
> It moves the cpuacct structure definition and some helper functions early
> in the file so we can access its members from here on.
>
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Paul Tuner <pjt@google.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |   77 +++++++++++++++++++++++++++----------------------------
>  1 files changed, 38 insertions(+), 39 deletions(-)

Bad news -- You've run afoul of a massive file re-structuring conflict :(

All of sched has been refactored under "kernel/sched/"; sched.c and
friends don't exist anymore.

- Paul
