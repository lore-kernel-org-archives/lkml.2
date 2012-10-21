Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2JUHzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 03:55:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37883 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2JUHzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 03:55:47 -0400
MIME-Version: 1.0
In-Reply-To: <1349755264-23876-1-git-send-email-ming.lei@canonical.com>
References: <1349755264-23876-1-git-send-email-ming.lei@canonical.com>
Date: Sun, 21 Oct 2012 15:55:45 +0800
Message-ID: <CACVXFVObsMY6fngBCFoNhh0syuFNTOMwLxRqhhheiEYxzQ2Z=Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] firmware loader: misc changes
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 12:01 PM, Ming Lei <ming.lei@canonical.com> wrote:
> Hi,
>
> The first two are fixes' patch, the 3rd one is to enable
> caching firmware for direct loading, and the last one is
> a cleanup patch.
>
>  drivers/base/firmware_class.c |  266 +++++++++++++++++++++++------------------
>  1 file changed, 151 insertions(+), 115 deletions(-)

Hi Greg,

Could you push the patchset or at least the first 3 fix patches
onto 3.7-rc?

BTW: 3/4 is still a fix, since linus's direct loading breaks firmware cache
which has been used by some drivers(such as: ath9k)


Thanks,
--
Ming Lei
