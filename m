Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab1GUPt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:49:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57468 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1GUPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:49:56 -0400
MIME-Version: 1.0
In-Reply-To: <20110720190036.GB21753@redhat.com>
References: <20110720185959.GA21749@redhat.com>
	<20110720190036.GB21753@redhat.com>
Date: Thu, 21 Jul 2011 21:19:55 +0530
Message-ID: <CAKTCnzkdZyidG3Qsdt7wFhkQMcz1wJCHY9AezSvb4rT4KTjMnQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] taskstats: add_del_listener() should ignore !valid listener's
From: Balbir Singh <bsingharora@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 12:30 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> When send_cpu_listeners() finds the orphaned listener it marks
> it as !valid and drops listeners->sem. Before it takes this sem
> for wrinting, s->pid can be reused and add_del_listener() can
> wrongly try to re-use this entry.
>
> Change add_del_listener() to check ->valid = T.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Balbir Singh <bsingharora@gmail.com>

BTW, some namespace changes are pending from my side. I need to get
it, its on my TODO list

Balbir Singh
