Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0JaXos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 19:44:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32947 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab0JaXoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 19:44:46 -0400
Date: Sun, 31 Oct 2010 19:44:43 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Marc Koschewski <marc@osknowledge.org>
Cc: Linux-LKLM <linux-kernel@vger.kernel.org>,
        Massimo Dal Zotto <dz@debian.org>
Subject: Re: [i8k] GIT current's i8k module does not load on Inspiron 8200
 laptops
Message-ID: <20101031234443.GA8332@bombadil.infradead.org>
References: <20101002081811.GA9024@marc.osknowledge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101002081811.GA9024@marc.osknowledge.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 10:19:08AM +0200, Marc Koschewski wrote:
> Hey folks,
> 
> the i8k module does no longer load on my DELL Inspiron 8200 laptops. It says this on one machine:
> 
> Oct  2 10:06:01 marc kernel: [   16.239867] i8k: unable to get SMM Dell
> signature
> 
> Due to git log there's nothing changed for a while and I cannot figure out, what's the problem. Does anyone of you?
> 

Apparently this is a recent GCC issue caused by optimization of the
inline asm. Making the asm volatile seems to work around the problem
according to reporters.

See https://bugzilla.redhat.com/show_bug.cgi?id=647677 and
https://bbs.archlinux.org/viewtopic.php?pid=780692#p780692.

regards, Kyle
