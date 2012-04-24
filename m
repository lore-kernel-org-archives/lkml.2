Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab2DXJTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 05:19:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479Ab2DXJTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 05:19:50 -0400
Message-ID: <4F96705C.5030901@suse.cz>
Date: Tue, 24 Apr 2012 11:20:28 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuld: Implement oldmodconfig
References: <m1aa22rllb.fsf@fess.ebiederm.org>
In-Reply-To: <m1aa22rllb.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 24.4.2012 02:59, Eric W. Biederman napsal(a):
> 
> While verifying that my user namespace patches are as complete as I
> expect them to be I came a came across the need to build kernel
> configurations with a few choice settings disabled and everything else
> enabled.  Adding a make oldmodconfig made generating those
> configurations straight forward, as now I can set the options I care
> about and the oldmodconfig can answering everything else for me in a
> consistent way.

Doesn't

KCONFIG_ALLCONFIG=base.config make allmodconfig

do the same thing? If not, the difference should be explained in the
changelog.

Michal
