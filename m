Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1BNT4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:56:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab1BNT4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:56:38 -0500
Date: Mon, 14 Feb 2011 20:47:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 0/3] procfs wrt pid namespace cleanups
Message-ID: <20110214194715.GB20765@redhat.com>
References: <1297710963-19843-1-git-send-email-daniel.lezcano@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297710963-19843-1-git-send-email-daniel.lezcano@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Daniel Lezcano wrote:
>
>         * removed buggy patch #4 from the initial patchset

Hmm. probably it was me who confused you... I am sorry if this is true.

I don't think that patch was buggy.  What I meant, it looks like
the preparation for the next changes
(http://kerneltrap.org/mailarchive/linux-kernel/2010/6/20/4585095)
and those changes are not correct.

In fact, 1/3 looks the same.

Anyway, this series looks correct.

Oleg.

