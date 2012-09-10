Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2IJOHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:07:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58865 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab2IJOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:07:43 -0400
Date: Mon, 10 Sep 2012 11:07:38 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: 3.4.10 i915 [GM45] regression
Message-ID: <20120910140734.GC2972@herton-Z68MA-D2H-B3>
References: <2372445.fuIXicT4H0@tux200s>
 <20120907011542.GA26688@kroah.com>
 <2329337.9aFzn0oRxF@tux200s>
 <CAKMK7uHqk1x4dM9ZA0usskNoArR6eTFmEtVw+_juzVq1NeYg+A@mail.gmail.com>
 <20120910135803.GB2972@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910135803.GB2972@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:58:03AM -0300, Herton Ronaldo Krzesinski wrote:
> Couldn't it be that it happens because 3.4 doesn't have commits
> b7884eb45ec98c0d34c7f49005ae9d4b4b4e38f6 and
> f01db988ef6f6c70a6cc36ee71e4a98a68901229 applied? May be they are needed
> after all.

Nevermind, the description on the freedesktop bug report states that
these commits were already tried and didn't work (if "3.4.10 + follow-up
patches in Herton's reply - failed" means it)

-- 
[]'s
Herton
