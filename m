Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2AWQuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:50:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35139 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2AWQuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:50:02 -0500
MIME-Version: 1.0
In-Reply-To: <1327098907-28963-1-git-send-email-tyhicks@canonical.com>
References: <1327098907-28963-1-git-send-email-tyhicks@canonical.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jan 2012 08:49:40 -0800
X-Google-Sender-Auth: 8INuhtMwB8EKAsHIDT7GS2HxiO0
Message-ID: <CA+55aFzpM-c9FWdC8+7sV0GOXqvFNvxPsrV42rvXJHXnKsDoZg@mail.gmail.com>
Subject: Re: eCryptfs: Truncate path improvements
To: Tyler Hicks <tyhicks@canonical.com>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, john.johansen@canonical.com,
        dustin.kirkland@gazzang.com, Cong Wang <xiyou.wangcong@gmail.com>,
        Li Wang <liwang@nudt.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 2:35 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
> As Linus pointed out[1], eCryptfs needs more checks around its truncate path.
> The first patch in this series makes it possible for an eCryptfs truncate
> operation to be gracefully interrupted by a fatal signal. The second adds
> checks for eCryptfs inode changes in setattr. The third is simply removal of
> an old, unused function.

Tyler, should I take these patches directly? Or are these just for
review and I should wait for a pull request?

                        Linus
