Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934652Ab0HEW1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:27:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760793Ab0HEW1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:27:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Roland Dreier <rdreier@cisco.com>
X-Fcc: ~/Mail/linus
Cc: Yegor Yefremov <yegorslists@googlemail.com>,
        Tiago Maluta <tiago.maluta@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fix CONFIG_CROSS_COMPILE issue in .config
In-Reply-To: Roland Dreier's message of  Thursday, 5 August 2010 14:37:07 -0700 <adaocdg3fng.fsf@roland-alpha.cisco.com>
References: <AANLkTim2mi0wbJJl17OkbCJbRt-s5phR4sumn5GsJKUp@mail.gmail.com>
	<20100621120613.86cad1a4.akpm@linux-foundation.org>
	<4C1FC35C.8090201@suse.cz>
	<AANLkTil2-YNAa-jyOYD4cNtbJQ1XQJ6-v3iJ6wxpz7br@mail.gmail.com>
	<AANLkTinC6Sqs7W--=14nmJFDcTS4HQn0=ysn7VhYDDX6@mail.gmail.com>
	<adaocdg3fng.fsf@roland-alpha.cisco.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100805222623.39A3240208@magilla.sf.frob.com>
Date: Thu,  5 Aug 2010 15:26:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, this make sense to me.  It's not clear to me why we ever needed
> the conditional assignment of an empty CROSS_COMPILE (that code predates
> the start of git history) [...]

Perhaps someone used make --warn-undefined-variables.
