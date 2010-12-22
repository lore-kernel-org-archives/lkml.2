Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0LVQJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:09:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab0LVQJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:09:04 -0500
Date: Wed, 22 Dec 2010 17:02:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 12/16] ptrace: make group stop notification reliable
	against ptrace
Message-ID: <20101222160203.GB11722@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-13-git-send-email-tj@kernel.org> <20101220173425.GA18070@redhat.com> <20101221174319.GH13285@htj.dyndns.org> <20101222115409.GB30266@redhat.com> <20101222152621.GD8061@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101222152621.GD8061@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22, Tejun Heo wrote:
>
> I don't think the previous code fared any better tho.

Heh, the previous code is much worse, sure ;)

Oleg.

