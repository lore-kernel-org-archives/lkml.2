Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2HMQ5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:57:13 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54962 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab2HMQ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:57:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120813163452.GB9180@google.com>
References: <1344874672-6257-1-git-send-email-js1304@gmail.com>
	<1344874672-6257-4-git-send-email-js1304@gmail.com>
	<20120813163452.GB9180@google.com>
Date: Tue, 14 Aug 2012 01:57:10 +0900
Message-ID: <CAAmzW4P23=XDd6r1cJmz4R8Q4wotyhGx-6u=B=cmMofUj36Bng@mail.gmail.com>
Subject: Re: [PATCH 4/5] workqueue: use system_highpri_wq for highpri workers
 in rebind_workers()
From: JoonSoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it would be better to just opencode system_wq selection in
> rebind_workers().

Sorry for my poor English skill.
Could you elaborate "opencode system_wq selection" means?

Thanks!
