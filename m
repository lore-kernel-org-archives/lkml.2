Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0KTA20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 19:28:26 -0500
Received: from mail.openrapids.net ([64.15.138.104]:42230 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751398Ab0KTA2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 19:28:25 -0500
Date: Fri, 19 Nov 2010 19:28:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC] lttngtrace available to non-root
Message-ID: <20101120002823.GA22308@Krystal>
References: <20101119222112.GA32294@Krystal> <20101120002152.GA12529@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101120002152.GA12529@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:27:47 up 58 days,  4:29,  3 users,  load average: 0.20, 0.17,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
[...]
> I'm also thinking to use mktemp for the next version to create a temporary
> file rather than the hardcoded file I'm using now. I could save the
> information about the last file name used in the user's home directory.

Don't worry, I'll use mkstemp, not mktemp ;)

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
