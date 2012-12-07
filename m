Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030592Ab2LGOCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:02:43 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48452 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030510Ab2LGOCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:02:42 -0500
Date: Fri, 7 Dec 2012 23:02:38 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: mtosatti@redhat.com, gleb@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 10/10] kvm: Increase user memory slots on x86 to 125
Message-Id: <20121207230238.7049d19fe0dc274910fb72da@gmail.com>
In-Reply-To: <20121206222126.24968.17280.stgit@bling.home>
References: <20121206214722.24968.6043.stgit@bling.home>
	<20121206222126.24968.17280.stgit@bling.home>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Dec 2012 15:21:26 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> With the 3 private slots, this gives us a nice round 128 slots total.

So I think this patch needs to be applied after resolving the
slot_bitmap issue.  We may not need to protect slots with large
slot id values, but still it's possible to do so.

Taking into account that the merge window is so close that this
patch set should be targeted for 3.9, it may be possible to do
the work timely: I will post my patch series next week if possible.

Thanks,
	Takuya
