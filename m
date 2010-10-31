Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab0JaR3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:29:40 -0400
Received: from xenotime.net ([72.52.115.56]:54315 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756447Ab0JaR3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:29:38 -0400
Date: Sun, 31 Oct 2010 10:29:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "wzabolot@elektron.elka.pw.edu.pl" <W.Zabolotny@elka.pw.edu.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel configuration should warn when KMS is switched on but
 framebuffer console is not?
Message-Id: <20101031102928.b7353c20.rdunlap@xenotime.net>
In-Reply-To: <4CCC1EF3.1050007@elektron.elka.pw.edu.pl>
References: <4CC751E8.9030505@elektron.elka.pw.edu.pl>
	<4CC7DDCC.7040605@elka.pw.edu.pl>
	<4CCB39BE.4080400@elektron.elka.pw.edu.pl>
	<4CCB41E5.7030708@elektron.elka.pw.edu.pl>
	<4CCC1EF3.1050007@elektron.elka.pw.edu.pl>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Oct 2010 15:34:43 +0200 wzabolot@elektron.elka.pw.edu.pl wrote:

> To avoid the problems described in the above bug reports, maybe the kernel
> configuration should check and warn when CONFIG_DRM_I915_KMS is set to "y"
> while CONFIG_FRAMEBUFFER_CONSOLE is not set to "y"?

What "above bug reports" are you referring to, please?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
