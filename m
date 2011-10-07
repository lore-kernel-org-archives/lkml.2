Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab1JGDay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:30:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59955 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab1JGDax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:30:53 -0400
Date: Fri, 7 Oct 2011 05:30:48 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "hpanvin@gmail.com" <hpa@zytor.com>
Cc: Josh Stone <jistone@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] x86: Make variable_test_bit reference all of *addr
Message-ID: <20111007033048.GA14482@one.firstfloor.org>
References: <1317945508-19575-1-git-send-email-jistone@redhat.com> <990b8719-066b-4e1d-892f-6a3ea4241fb2@email.android.com> <m2d3e936fn.fsf@firstfloor.org> <4E8E690C.9010206@redhat.com> <84050df0-7a6c-4dbe-85b7-ed9e98a813aa@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84050df0-7a6c-4dbe-85b7-ed9e98a813aa@email.android.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 08:12:48PM -0700, hpanvin@gmail.com wrote:
> I mean the volatile in "asm volatile".

That volatile has nothing to do with memory. It just means "don't move
much". It's actually quite vague, because the rest of the function
can still move around.

-Andi
