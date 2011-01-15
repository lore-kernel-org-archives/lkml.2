Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1AONDx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 08:03:53 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58551 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab1AONDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 08:03:52 -0500
Date: Sat, 15 Jan 2011 11:03:48 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Han Pingtian <phan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf test: check if cpu_map__new() return NULL
Message-ID: <20110115130348.GA26476@ghostprotocols.net>
References: <20110114230050.GA7011@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114230050.GA7011@localhost>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jan 15, 2011 at 07:00:50AM +0800, Han Pingtian escreveu:
> It looks like we should check if cpus is NULL after
> 
> 	cpus = cpu_map__new(NULL);
> 
> in test__open_syscall_event_on_all_cpus().

Right, thanks,

- Arnaldo
