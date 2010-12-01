Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0LABI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:08:28 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42425 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab0LABI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:08:27 -0500
Date: Tue, 30 Nov 2010 23:08:21 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf:  remove dep on -lelf during libaudit check
Message-ID: <20101201010821.GB18833@ghostprotocols.net>
References: <1291155133-3499-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291155133-3499-1-git-send-email-dzickus@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 30, 2010 at 05:12:12PM -0500, Don Zickus escreveu:
> If your machine does not have the elfutils-devel installed on it,
> then the check of libaudit will fail even though the machine has
> the audit-libs-devel package installed.
> 
> The check for -lelf is unneeded.

Ingo, this one is just for tip/master,

- Arnaldo
