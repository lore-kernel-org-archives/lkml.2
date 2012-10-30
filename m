Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab2J3Oh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:37:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759391Ab2J3Oh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:37:58 -0400
Date: Tue, 30 Oct 2012 10:37:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Patch 0/2] Exclude hwpoison page from vmcore dump
Message-ID: <20121030143750.GF2290@redhat.com>
References: <508FDEF3.8030601@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508FDEF3.8030601@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 11:06:43PM +0900, Mitsuhiro Tanino wrote:

[..]
> These patches introduce a new "-p" option into "makedumpfile" to
> exclude hwpoison page from vmcore.

Why to introduce this option "-p"? Until and unless there are serious
side effects, this should be default functionality. Isn't it? Who would
like to touch/save poisoned pages and run into MCE?

Thanks
Vivek
