Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab2BJRsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:48:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759375Ab2BJRsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:48:45 -0500
Date: Fri, 10 Feb 2012 18:42:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pedro Alves <palves@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ptrace: remove PTRACE_SEIZE_DEVEL bit
Message-ID: <20120210174212.GA10011@redhat.com>
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com> <1328884991-23889-2-git-send-email-vda.linux@googlemail.com> <1328884991-23889-3-git-send-email-vda.linux@googlemail.com> <1328884991-23889-4-git-send-email-vda.linux@googlemail.com> <1328884991-23889-5-git-send-email-vda.linux@googlemail.com> <1328884991-23889-6-git-send-email-vda.linux@googlemail.com> <20120210172427.GE8908@redhat.com> <4F3557D9.7000408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3557D9.7000408@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Pedro Alves wrote:
>
> Do new auto-attached clones still generate SIGSTOP, or has than been fixed already?

Hopefully fixed by d184d6eb
"ptrace: dont send SIGSTOP on auto-attach if PT_SEIZED"

Oleg.

