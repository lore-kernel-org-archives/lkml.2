Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0KCXZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 19:25:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab0KCXZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 19:25:45 -0400
Message-ID: <4CD1EF71.1090303@suse.cz>
Date: Thu, 04 Nov 2010 00:25:37 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild, deb-pkg: fix Architecture field when cross compiling
References: <1288654261-8269-1-git-send-email-asbjorn@asbjorn.biz> <4CD1E8C4.2020405@suse.cz>
In-Reply-To: <4CD1E8C4.2020405@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.11.2010 23:57, Michal Marek wrote:
> build a kernel for a different architecture. make rpm-pkg seems to
> suffer from the same problem, btw.

rpm-pkg actually handles this properly, it runs rpmbuild --target
$(UTS_MACHINE).

Michal
