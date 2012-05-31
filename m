Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab2EaOiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:38:07 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46579 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab2EaOh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:37:59 -0400
Date: Thu, 31 May 2012 11:37:08 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf tools: Update ioctl documentation for
 PERF_IOC_FLAG_GROUP
Message-ID: <20120531143708.GE13591@infradead.org>
References: <1338443506-25009-1-git-send-email-namhyung.kim@lge.com>
 <1338443506-25009-2-git-send-email-namhyung.kim@lge.com>
 <20120531143554.GD13591@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531143554.GD13591@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 31, 2012 at 11:35:54AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, May 31, 2012 at 02:51:45PM +0900, Namhyung Kim escreveu:
> > The ioctl interface of perf event fd receives 3 arguments
> > to control event group behavior but it lacked documentation.
> 
> But the argument is not used for ENABLE or DISABLE, so why require it?

Nevermind, colour me blind, applying.

- Arnaldo
