Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1LTVVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 16:21:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:35334 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab1LTVVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 16:21:05 -0500
Message-ID: <1324416051.24621.54.camel@twins>
Subject: Re: [PATCH 2/3] perf, tool: Add new event group management
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Tue, 20 Dec 2011 22:20:51 +0100
In-Reply-To: <20111220174724.GD22107@infradead.org>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
	 <1323963039-7602-3-git-send-email-jolsa@redhat.com>
	 <20111220174724.GD22107@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-20 at 15:47 -0200, Arnaldo Carvalho de Melo wrote:
> Looks awesome! Peter, comments? All OK with you?

Read my replies, not really. I'm ok with the idea, but I think we should
take this possibility to clean up the syntax, sod backward compat.
