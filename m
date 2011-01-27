Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1A0ASl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:18:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471Ab1A0ASk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:18:40 -0500
Date: Wed, 26 Jan 2011 16:18:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup : remove the ns_cgroup
Message-Id: <20110126161837.43830756.akpm@linux-foundation.org>
In-Reply-To: <1295948388-15108-1-git-send-email-daniel.lezcano@free.fr>
References: <1295948388-15108-1-git-send-email-daniel.lezcano@free.fr>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 10:39:48 +0100
Daniel Lezcano <daniel.lezcano@free.fr> wrote:

> This patch removes the ns_cgroup as suggested in the following thread:

I had this patch queued up in September last year, but dropped it.  Why
did I do that?
