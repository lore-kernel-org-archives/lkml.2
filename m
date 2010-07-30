Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab0G3Lwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 07:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157Ab0G3Lwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 07:52:38 -0400
Date: Fri, 30 Jul 2010 13:51:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tomasz Buchert <tomasz.buchert@inria.fr>
Cc: linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/4] Wall time clocks + change in access rules
Message-ID: <20100730135159.596eafe6@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20100730132343.4c15bfdc@dhcp-lab-109.englab.brq.redhat.com>
References: <1280483867-6387-1-git-send-email-tomasz.buchert@inria.fr>
	<20100730132343.4c15bfdc@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 13:23:43 +0200
Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Anyway, I think we need better rationale, before we can consider your wall 
> clock patches inclusion into the kernel.

To clarify. I'm not against your patches. I just would like to know 
why patches are needed (or maybe even how they are used) to see if there
is no other/better way to solve your problem. We do not want add new
code to kernel (and what more important - maintain it), if problem can
be solved differently.

Stanislaw
