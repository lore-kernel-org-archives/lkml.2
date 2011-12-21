Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1LULzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:55:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab1LULzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:55:12 -0500
Date: Wed, 21 Dec 2011 09:54:55 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] perf, tool: Add new event group management
Message-ID: <20111221115455.GA30221@infradead.org>
References: <1323963039-7602-1-git-send-email-jolsa@redhat.com> <1323963039-7602-3-git-send-email-jolsa@redhat.com> <20111220174724.GD22107@infradead.org> <1324416051.24621.54.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324416051.24621.54.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 20, 2011 at 10:20:51PM +0100, Peter Zijlstra escreveu:
> On Tue, 2011-12-20 at 15:47 -0200, Arnaldo Carvalho de Melo wrote:
> > Looks awesome! Peter, comments? All OK with you?
> 
> Read my replies, not really. I'm ok with the idea, but I think we should
> take this possibility to clean up the syntax, sod backward compat.

Ok, I meant the idea mostly, didn't looked that much at the syntax and
haven't taken any of those patches :)

- Arnaldo
