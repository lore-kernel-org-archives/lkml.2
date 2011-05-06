Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab1EFEGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 00:06:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41392 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1EFEGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 00:06:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=yHU5tsgz9bXkTUaQEbBfUvcQ6Vn0BNpILv2mF6/cbI/H5QIM0Ymqq0697V04iIul7G
         xBcwQByoc7XT8Dv4LAVKoOSrDrf6tvcyWwBBm0/nIaK5A3VMi/hRemI/dA2swAHxA7DB
         JpxMhiUpDafM/tDJCQuxqHPT8a3KfCgtVQkTk=
MIME-Version: 1.0
In-Reply-To: <20110506030821.523093711@intel.com>
References: <20110506030821.523093711@intel.com>
Date: Fri, 6 May 2011 07:06:42 +0300
Message-ID: <BANLkTimaf29+FDJV-6L3Jv5JQ9EvvOJrfA@mail.gmail.com>
Subject: Re: [PATCH 00/17] writeback fixes and cleanups for 2.6.40
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 6, 2011 at 6:08 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> The patches are also git pullable from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git fs-writeback

git pull git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git
fs-writeback
fatal: Couldn't find remote ref fs-writeback


git ls-remote git://git.kernel.org/pub/scm/linux/kernel/git/wfg/writeback.git
5895198c56d131cc696556a45f7ff0ea99ac297b	HEAD
dbe30770c0b9d280742d3ef0c12b8187ce6e19a7	refs/heads/dirty-throttling-v2
a56422a5103f57066e401e1d506f1e0cadbe3ad7	refs/heads/dirty-throttling-v3
1fe1fbdcbcd2bc1a0034ec84a927222b3278dca9	refs/heads/dirty-throttling-v4
6b7ca194675e2fb4aaf4394df3aedfda69ab14a4	refs/heads/dirty-throttling-v5
5f35306e8d2e56dd6973556a5b844e4eb8ce24c4	refs/heads/dirty-throttling-v6
d0e30163e390d87387ec13e3b1c2168238c26793	refs/heads/dirty-throttling-v7
5895198c56d131cc696556a45f7ff0ea99ac297b	refs/heads/master
...

no branch fs-writeback.
