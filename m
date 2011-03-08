Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab1CHUCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:02:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756024Ab1CHUCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:02:30 -0500
MIME-Version: 1.0
In-Reply-To: <1299614199-25142-1-git-send-email-tj@kernel.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Mar 2011 12:01:40 -0800
Message-ID: <AANLkTinWp0cUGD4FxLpvSMcb0kYrbyQB_76u3CYjiNJy@mail.gmail.com>
Subject: Re: [RFC PATCHSET] ptrace,signal: Fix notifications to the real
 parent while ptraced
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, indan@nul.nu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 11:56 AM, Tejun Heo <tj@kernel.org> wrote:
>
> This patchset implements "P2. Fix notifications to the real parent" of
> the ptrace job control improvements proposal[1].

Ok, from skimming the patches, I like the whole series. I especially
liked how all the steps were small and well-commented, both in the
code and in the changelog. I could basically follow the patch series
from just reading the changelogs, and the patches themselves looked
fine too.

                        Linus
