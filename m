Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1CWSPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:15:40 -0400
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:45667 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932098Ab1CWSPj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:15:39 -0400
MIME-Version: 1.0
In-Reply-To: <1300902477-6608-1-git-send-email-roland@kernel.org>
References: <1300902477-6608-1-git-send-email-roland@kernel.org>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 23 Mar 2011 11:15:17 -0700
X-Google-Sender-Auth: NpPv-mI4I5XJcJCocPRmD-8ffdA
Message-ID: <AANLkTimGvTrus1r38pPN4v0ZUgN-dqoUaR-JH93SSrCz@mail.gmail.com>
Subject: Re: [GIT PULL] please pull infiniband.git
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 10:47 AM, Roland Dreier <roland@kernel.org> wrote:
> drivers/infiniband/core/addr.c           |    2 +-
>  drivers/infiniband/core/agent.c          |    3 +-
>  drivers/infiniband/hw/mthca/mthca_main.c |    3 +
>  drivers/infiniband/hw/nes/nes.c          |    2 +-
>  drivers/infiniband/ulp/srp/ib_srp.c      |  725 ++++++++++++++++++++----------
>  drivers/infiniband/ulp/srp/ib_srp.h      |   38 ++-
>  6 files changed, 521 insertions(+), 252 deletions(-)

Somehow I missed a hunk of

 IB: Increase DMA max_segment_size on Mellanox hardware

diffstat now should look like

 drivers/infiniband/core/addr.c           |    2 +-
 drivers/infiniband/core/agent.c          |    3 +-
 drivers/infiniband/hw/mthca/mthca_main.c |    3 +
 drivers/infiniband/hw/nes/nes.c          |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c      |  725 ++++++++++++++++++++----------
 drivers/infiniband/ulp/srp/ib_srp.h      |   38 ++-
 drivers/net/mlx4/main.c                  |    3 +
 7 files changed, 524 insertions(+), 252 deletions(-)
