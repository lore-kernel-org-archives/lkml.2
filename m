Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1GUSCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:02:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab1GUSCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:02:44 -0400
Date: Thu, 21 Jul 2011 20:00:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>
Cc: mtk.manpages@gmail.com, Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] (Was: man ptrace: add extended description of various
	ptrace quirks)
Message-ID: <20110721180019.GA1319@redhat.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com> <20110721165137.GA21345@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721165137.GA21345@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21, Oleg Nesterov wrote:
>
> IIRC, we already discussed this... The traced group leader can
> disappear during mt-exec,

Hmm. But the tracer should not block in do_wait() in this case
anyway...

Oleg.

