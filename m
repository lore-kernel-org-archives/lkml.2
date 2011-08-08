Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1HHOD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:03:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50665 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab1HHOD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:03:27 -0400
Date: Mon, 8 Aug 2011 16:03:26 +0200
From: Michal Marek <mmarek@suse.cz>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 2/2] kconfig: factor code in menu_get_ext_help()
Message-ID: <20110808140325.GB11427@sepie.suse.cz>
References: <1312422727-9740-1-git-send-email-lacombar@gmail.com>
 <1312422727-9740-2-git-send-email-lacombar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312422727-9740-2-git-send-email-lacombar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 09:52:07PM -0400, Arnaud Lacombe wrote:
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  scripts/kconfig/menu.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)

Applied to kbuild-2.6.git#kconfig.

Michal
