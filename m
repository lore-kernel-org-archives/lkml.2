Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1H0OkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:40:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37353 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1H0OkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110826220311.GA18140@fieldses.org>
References: <1312810169.2591.1153.camel@deadeye> <20110808155538.GB904@fieldses.org>
 <20110808180658.GC29924@decadent.org.uk> <20110826220311.GA18140@fieldses.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 27 Aug 2011 10:39:55 -0400
Message-ID: <CAMjpGUdJOh0=trV8vA9D3_uL27STo7MwbabwC9JHi1nVMwWLrA@mail.gmail.com>
Subject: Re: [PATCH] All Arch: remove linkage for sys_nfsservctl system call
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Neil Brown <neilb@suse.de>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 18:03, J. Bruce Fields wrote:
>  arch/blackfin/mach-common/entry.S      |    2 +-

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
