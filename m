Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1KLJWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 04:22:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49603 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab1KLJWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 04:22:16 -0500
Subject: Re: [PATCH] sched: don't call task_group() many times in
 set_task_rq()
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Andrew Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, devel@openvz.org
Date: Sat, 12 Nov 2011 10:21:58 +0100
In-Reply-To: <4EBD92ED.4050701@google.com>
References: <1321020240-3874331-1-git-send-email-avagin@openvz.org>
	 <4EBD92ED.4050701@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321089719.30500.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-11 at 13:26 -0800, Paul Turner wrote:
> Signed-off-by: Paul Turner <pjt@google.com>

I'll take that as Acked-by, ok?
