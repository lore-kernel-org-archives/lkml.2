Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934311Ab2C3Tuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 15:50:51 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37744 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab2C3Tus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 15:50:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120330175106.GB755@shiny>
References: <20120330175106.GB755@shiny>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Mar 2012 12:50:26 -0700
X-Google-Sender-Auth: UYTw9ejITTfH8uZoGihUyDSO-lY
Message-ID: <CA+55aFwFkeR8pNo7dF1gr0VPD9hr+9zB8zoc_byvMxSzr2WEZw@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs fixes and features
To: Chris Mason <chris.mason@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 10:51 AM, Chris Mason <chris.mason@oracle.com> wrote:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This causes a new warning for me:

  fs/btrfs/extent_io.c: In function ‘repair_eb_io_failure’:
  fs/btrfs/extent_io.c:1940:6: warning: ‘ret’ may be used
uninitialized in this function

Hmm?

                Linus
