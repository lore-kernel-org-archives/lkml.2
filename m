Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2BADmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 22:42:40 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40690 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752531Ab2BADmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 22:42:39 -0500
Message-ID: <1328067755.14714.39.camel@joe2Laptop>
Subject: Re: [PATCH 1/4] coda: Remove unnecessary OOM messages
From: Joe Perches <joe@perches.com>
To: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Ryan Mallon <rmallon@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 31 Jan 2012 19:42:35 -0800
In-Reply-To: <189650fe-7304-4762-a353-e355609f3e84@email.android.com>
References: <cover.1328049542.git.joe@perches.com>
	 <db4ffce1e5a8a3a6e54e7a4f6487e822709dbdba.1328049542.git.joe@perches.com>
	 <4F288178.4040405@gmail.com> <1328055665.14714.5.camel@joe2Laptop>
	 <4F2885EC.8070900@gmail.com> <1328055976.14714.7.camel@joe2Laptop>
	 <189650fe-7304-4762-a353-e355609f3e84@email.android.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 22:10 -0500, Jan Harkes wrote:
> Joe Perches <joe@perches.com> wrote:
> >On Wed, 2012-02-01 at 11:23 +1100, Ryan Mallon wrote:
> >> On 01/02/12 11:21, Joe Perches wrote:
> >> > Maybe because alloc/free functions are
> >> > used relatively infrequently, maybe it'd
> >> > be better to not declare the functions
> >> > inline but add them to coda_linux.c
> >> Sure, either approach is fine. Do you want to add the patch to your
> >series?
> >I think Jan can work it out properly if he wants it.
> It looks good to me, I have no problem if you want to add it to your series.

(adding Al Viro and Andrew Morton to cc:)

Hi Jan.

I think Ryan's patches are fine as well.

>From my perspective as a contributor, you should ack the
patches you apply to your own tree with your own
"Signed-off-by:" tag and later send a pull request to
Linus or another upstream maintainer like Al Viro or you
should ack the patches and forward them to another upstream
maintainer to be applied in their tree with your "Acked-by:"
tag.

cheers, Joe

