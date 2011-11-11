Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1KKVsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 16:48:00 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40207 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1KKVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 16:47:59 -0500
Message-ID: <4EBD980B.7040300@google.com>
Date: Fri, 11 Nov 2011 13:47:55 -0800
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.openvz.devel
To: Andrew Vagin <avagin@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] sched: don't call task_group() many times in set_task_rq()
References: <1321020240-3874331-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1321020240-3874331-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For future note, please keep lists that don't allow cross-posting out of CC:

"You are not allowed to post to this mailing list, and your message has
been automatically rejected.  If you think that your messages are
being rejected in error, contact the mailing list owner at
devel-owner@openvz.org."

Thanks,

- Paul
