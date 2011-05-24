Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab1EXPsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:48:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab1EXPsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:48:52 -0400
Message-ID: <4DDBD362.4000900@suse.cz>
Date: Tue, 24 May 2011 17:48:50 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rpm-pkg: Fix when current directory is a symlink
References: <1304542185-14520-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1304542185-14520-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.5.2011 22:49, Michal Marek wrote:
> The better fix would be to stop using the parent directory (principle of
> least surprise), but as long as we use it, use it consistently.
>
> Signed-off-by: Michal Marek<mmarek@suse.cz>

Pushed to kbuild-2.6.git#packaging.

Michal
