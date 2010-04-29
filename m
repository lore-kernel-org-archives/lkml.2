Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab0D2DF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 23:05:59 -0400
Received: from lo.gmane.org ([80.91.229.12]:55264 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab0D2DF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:05:58 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Very bad regression from 2.6.33 as of 1600f9def
Date: Thu, 29 Apr 2010 03:05:48 +0000 (UTC)
Message-ID: <loom.20100429T045742-593@post.gmane.org>
References: <loom.20100429T041908-663@post.gmane.org> <4BD8F457.10205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 98.117.134.248 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.3) Gecko/20100409 Firefox/3.6.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock <justinmattock <at> gmail.com> writes:
> 
> what is the last good kernel?
> can you bisect this?
> 
> Justin P. Mattock
> 

Last good kernel was 2.6.33 release, right after tagging.
I'll try and bisect. Probably be a while before I have anything,
since the CPU is rather slow. Hopefully last good will work in qemu.

