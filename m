Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab2ADBrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 20:47:07 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46128 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2ADBrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 20:47:01 -0500
MIME-Version: 1.0
In-Reply-To: <01bb01ccca79$ae1ad770$0a508650$%kim@samsung.com>
References: <20120103180854.e9bff732db50c0fa9afd2967@canb.auug.org.au>
 <010601ccc9ef$7e784640$7b68d2c0$%kim@samsung.com> <CA+55aFzuEP7poPj_TiC28+T7Xn-6G1Lydt=q5FMVTj_XhOVf3w@mail.gmail.com>
 <01bb01ccca79$ae1ad770$0a508650$%kim@samsung.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 3 Jan 2012 17:46:39 -0800
X-Google-Sender-Auth: H8OpPEUWOLiE5x8l5n7SpZCKfcA
Message-ID: <CA+55aFxgrLujQBPPTEiZk9a3GrvUpDhmR6eSd0Mg4O481MZKcg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the s5p tree
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 4:42 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>>
> The driver-core tree changed usage(?) of sysdev_class and touched some files
> and the changed files have been merged into one file for some reason without
> driver-core's changes in samsung tree. So I just wanted to avoid the
> conflicts. Linus, how should/can I do in  this case?

Generally, unless the conflicts are *really* bad, just ignore them,
and let me sort them out. It's nice if you mention the fact that there
will be conflicts, and some people also send me a pre-merged tree that
has the conflicts fixed up, but in general it's much better if the
different trees ignore each other - that way we don't have random
merges that mean that I cannot pull one tree without pulling another.

If the conflicts are just insanely bad, I'll ask you to resolve them
for me when I hit them, but in general that's a sign that something
nasty is going on and people are developing in the wrong trees or just
stepping on each others toes too much.

                   Linus
