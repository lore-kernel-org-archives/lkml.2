Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab1BMQIN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 11:08:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47706 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab1BMQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 11:08:09 -0500
MIME-Version: 1.0
In-Reply-To: <20110213155730.GK19533@dhcp231-156.rdu.redhat.com>
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com> <20110213155730.GK19533@dhcp231-156.rdu.redhat.com>
From: Marti Raudsepp <marti@juffo.org>
Date: Sun, 13 Feb 2011 18:07:36 +0200
Message-ID: <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com>
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP bug?
To: Josef Bacik <josef@redhat.com>
Cc: btrfs hackers <linux-btrfs@vger.kernel.org>,
        Kernel hackers <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 17:57, Josef Bacik <josef@redhat.com> wrote:
> Does the same problem happen when you use cp --sparse=never?

You are right. cp --sparse=never does not cause data loss.

Regards,
Marti
