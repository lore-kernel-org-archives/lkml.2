Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab2CaScW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 14:32:22 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53335 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab2CaScU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 14:32:20 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxmOEUCXeHtSAN+g3cSpFVvf5vPTSzZDtXdJs0Hq1rVZw@mail.gmail.com>
References: <20120331051906.GU6589@ZenIV.linux.org.uk> <CA+55aFxmOEUCXeHtSAN+g3cSpFVvf5vPTSzZDtXdJs0Hq1rVZw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 31 Mar 2012 11:31:58 -0700
X-Google-Sender-Auth: Q8wk3TdY_xS0zIpyD7ISrfz--Ec
Message-ID: <CA+55aFztRQHX+3KET_xdQd9TuEEuuGS6ogrKAEYGaWfd6m9rDA@mail.gmail.com>
Subject: Re: [git pull] vfs part 2
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 11:28 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It may be some other change than your pull... I will explore more, but
> I thought I'd let you know that it's the prime suspect right now.

Verified. My tree just before the pull works fine (current tip plus a
couple of my pending selinux avc optimizations). So it's your pull.

                      Linus
