Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2BBRJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:09:05 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48250 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2BBRJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:09:04 -0500
MIME-Version: 1.0
In-Reply-To: <1328181135.2279.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1311923731.7845.25.camel@edumazet-laptop> <1328181135.2279.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 2 Feb 2012 09:08:42 -0800
X-Google-Sender-Auth: BSbj5oSw8EToaoctzbq6fT8V5Xk
Message-ID: <CAG4TOxMVmEe3KiDuaO6ZWq0vNchi1Mrf=mr2RSNJY2oXX0hD+Q@mail.gmail.com>
Subject: Re: [PATCH] IB/ehca: use kthread_create_on_node
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 2, 2012 at 3:12 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Any news on this patch ?

Sorry, just dropped it in the shuffle.  I'll get it into 3.4, thanks.
