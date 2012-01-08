Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2AHQLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:11:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64279 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2AHQLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:11:36 -0500
Subject: Re: [PATCH 7/9] perf annotate: Get rid of field_sep check
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1326037339-31125-8-git-send-email-acme@infradead.org>
References: <1326037339-31125-1-git-send-email-acme@infradead.org>
	 <1326037339-31125-8-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 01:11:29 +0900
Message-ID: <1326039089.1947.12.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-08 (Sun), 13:42 -0200, Arnaldo Carvalho de Melo wrote:
> From: Namhyung Kim <namhyung@gmail.com>
> 
> The 'field_sep' variable is not set anywhere. Just remove the
> conditional.
> 

BTW, it seems there's no user of the variable now. Maybe a candidate
for removal?

Thanks.

-- 
Regards,
Namhyung Kim


