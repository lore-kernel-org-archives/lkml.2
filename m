Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab1IIJtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 05:49:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080Ab1IIJtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 05:49:05 -0400
Message-ID: <4E69E10F.5040804@suse.cz>
Date: Fri, 09 Sep 2011 11:49:03 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kbuild@vger.kernel.org
Subject: Re: [Patch] makefile: remove a duplicated line
References: <1313565052-7293-1-git-send-email-amwang@redhat.com>
In-Reply-To: <1313565052-7293-1-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.8.2011 09:10, Amerigo Wang wrote:
> There are two duplicated lines for 'make RECORDMCOUNT_WARN=1 [targets]'
> in 'make help', remove the second one.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Applied to kbuild-2.6.git#kbuild, thanks.

Michal
