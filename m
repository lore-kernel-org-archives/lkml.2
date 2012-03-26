Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab2CZVOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 17:14:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47686 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab2CZVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 17:14:10 -0400
MIME-Version: 1.0
In-Reply-To: <CD250C48050CFB4D95E78C95F2FDDD6E61A79B2E@MTLDAG02.mtl.com>
References: <1332177079-14339-1-git-send-email-roland@kernel.org> <CD250C48050CFB4D95E78C95F2FDDD6E61A79B2E@MTLDAG02.mtl.com>
From: Roland Dreier <roland@kernel.org>
Date: Mon, 26 Mar 2012 14:13:49 -0700
X-Google-Sender-Auth: yGIiz5MQ7eji9sxKNctZGyshBRQ
Message-ID: <CAG4TOxPHziBpJ5hAoVCQTJWeR+-uC+2vM9S0aKE-6-B9JCEkWQ@mail.gmail.com>
Subject: Re: [GIT PULL] please pull infiniband.git
To: Tziporet Koren <tziporet@mellanox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 2:04 PM, Tziporet Koren <tziporet@mellanox.com> wrote:
> What about the IPoIB patches (e.g. use Interrupt moderation)

I have no idea what patch that might be.  We've had the modify_cq call
in ipoib for years now,
with moderation parameters set through ethtool.

 - R.
