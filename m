Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab0LABGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:06:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab0LABGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:06:31 -0500
Date: Tue, 30 Nov 2010 23:06:17 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf: add memcpy to perf packaging
Message-ID: <20101201010617.GA18833@ghostprotocols.net>
References: <1291155133-3499-1-git-send-email-dzickus@redhat.com> <1291155133-3499-2-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291155133-3499-2-git-send-email-dzickus@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 30, 2010 at 05:12:13PM -0500, Don Zickus escreveu:
> There seems to be a new dependency on arch/*/lib/memcpy*.S when compiling
> the perf tool.  Make sure that file is included in the MANIFEST when
> creating the tarball.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Thanks, applied.

- Arnaldo
