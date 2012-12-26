Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab2LZE2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 23:28:23 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44418 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2LZE2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 23:28:22 -0500
X-AuditID: 9c930197-b7c5bae000000e31-96-50da7ce45b22
From: Namhyung Kim <namhyung@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools lib traceevent: test correct variable after allocation
References: <1356120062-2648-1-git-send-email-sasha.levin@oracle.com>
Date: Wed, 26 Dec 2012 13:28:19 +0900
In-Reply-To: <1356120062-2648-1-git-send-email-sasha.levin@oracle.com> (Sasha
	Levin's message of "Fri, 21 Dec 2012 15:00:58 -0500")
Message-ID: <874nj9tp24.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

On Fri, 21 Dec 2012 15:00:58 -0500, Sasha Levin wrote:
> we've tested the wrong variable for allocation failure, fix it to
> test the right one.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
