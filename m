Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2LJK3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:29:34 -0500
Received: from guarana.org ([59.167.251.209]:49083 "EHLO
	cheesypoof.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab2LJK3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:29:30 -0500
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 05:29:29 EST
Message-ID: <20121210211853.19957787m6em7c4k@guarana.org>
Date: Mon, 10 Dec 2012 21:18:53 +1100
From: Kevin Easton <kevin@guarana.org>
To: Tristan Wibberley <tristan.wibberley@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New system call wanted: fdreopen
References: <ka2982$ra3$1@ger.gmane.org>
In-Reply-To: <ka2982$ra3$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tristan Wibberley <tristan.wibberley@gmail.com>:

> Why
> ===
>
> A common idiom on Linux is to open a file and keep the fd open so that
> the underlying file can be unlinked from its directory. But if the file
> needs to be read from several different parts of the codebase then due to
> the file descriptor having exactly one read pointer those different parts
> must be synchronised which is a relatively difficult task.

Another alternative is to use pwrite() / pread(), which do not affect the file
pointer.  They're in POSIX.

     - Kevin


