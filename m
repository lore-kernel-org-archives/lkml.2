Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab1HAOUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 10:20:51 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:57743 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1HAOUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 10:20:46 -0400
MIME-Version: 1.0
In-Reply-To: <1312193592-6672-1-git-send-email-sonic.adi@gmail.com>
References: <1312193592-6672-1-git-send-email-sonic.adi@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 1 Aug 2011 07:20:25 -0700
Message-ID: <CAMjpGUdMEEM3r79b9DkwyaeFOaNn=DZXWuwtHk72wXEnk98Kpw@mail.gmail.com>
Subject: Re: [PATCH 2/2] serial:blackfin: Put TX IRQ in individual platform
 resource. Fix typo.
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 03:13, Sonic Zhang wrote:
> Fix typo in last patch.

this should be folded into the previous patch then so that you're
submitting known broken code
-mike
