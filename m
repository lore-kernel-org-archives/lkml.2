Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab2AREeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 23:34:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925Ab2AREeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 23:34:11 -0500
Message-ID: <1326861219.490.4.camel@cr0>
Subject: Re: [PATCH] kbuild: do not check for ancient modutils tools
From: Cong Wang <amwang@redhat.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        Michal Marek <mmarek@suse.cz>, linux-modules@vger.kernel.org
Date: Wed, 18 Jan 2012 12:33:39 +0800
In-Reply-To: <1326819051-25712-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1326819051-25712-1-git-send-email-lucas.demarchi@profusion.mobi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 14:50 -0200, Lucas De Marchi wrote:
> scripts/depmod.sh checks for the output of '-V' expecting that it has
> module-init-tools in it. It's a hack to prevent users from using
> modutils instead of module-init-tools, that only works with 2.4.x
> kernels. This however prints an annoying warning for kmod tool, that is
> currently replacing module-init-tools.
> 
> Rather than putting another check for kmod's version, just remove it
> since users of 2.4.x kernel are unlikely to upgrade to 3.x, and if they
> do, let depmod fail in that case because they should know what they are
> doing.
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>

Acked-by: WANG Cong <amwang@redhat.com>

Thanks.


