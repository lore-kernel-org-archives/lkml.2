Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab1JMOBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:01:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404Ab1JMOBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:01:42 -0400
Date: Thu, 13 Oct 2011 11:01:21 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu
Subject: Re: [PATCH] perf: fix compilation when NO_NEWT_SUPPORT is set
Message-ID: <20111013140121.GA18358@ghostprotocols.net>
References: <20111012120328.GA1619@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012120328.GA1619@quad>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 12, 2011 at 02:03:28PM +0200, Stephane Eranian escreveu:
> 
> This patch, relative to tip/master, makes perf compile
> when NO_NEWT_SUPPORT is set.  It also fixes the line
> formatting to fit 80 columns.
> 
> Please test with NO_NEWT.

Thanks, sorry about that.

- Arnaldo
