Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab2J2OfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:35:19 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:47272 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2J2OfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:35:17 -0400
Subject: Re: [PATCH] Documentation: insert an additional information to
 android.txt
From: Namhyung Kim <namhyung@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1351518066-4791-1-git-send-email-js1304@gmail.com>
References: <1351518066-4791-1-git-send-email-js1304@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Oct 2012 23:35:07 +0900
Message-ID: <1351521307.1617.2.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-29 (월), 22:41 +0900, Joonsoo Kim:
> Without defining ARCH=arm, building a perf for Android ARM will be failed,
> because it needs architecture specific files.
> So add related information to a document.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


