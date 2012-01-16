Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab2APVkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:40:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35033 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab2APVkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:40:23 -0500
MIME-Version: 1.0
In-Reply-To: <1326564981-7142-1-git-send-email-devendra.aaru@gmail.com>
References: <1326564981-7142-1-git-send-email-devendra.aaru@gmail.com>
From: Jesse Gross <jesse@nicira.com>
Date: Mon, 16 Jan 2012 13:40:01 -0800
Message-ID: <CAEP_g=-2qSjcobw0q0Rp9KUAZC9+PmedCntaXS0JNs7NnnggLw@mail.gmail.com>
Subject: Re: [PATCH 1/1] remove version.h includes in net/openvswitch/
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 10:16 AM, Devendra Naga <devendra.aaru@gmail.com> wrote:
> remove version.h includes in net/openswitch/ as reported by make versioncheck.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

I'm fine with the change (it's just a leftover from the out-of-tree
module), although in general please prefix the subject with the area
that it is modifying.
