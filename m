Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0IWPpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:45:08 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:53157 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab0IWPpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:45:07 -0400
Date: Thu, 23 Sep 2010 17:45:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 1/5] Makefile.fwinst: include Makefile.lib
Message-ID: <20100923154505.GB30836@merkur.ravnborg.org>
References: <1285255197-9262-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285255197-9262-1-git-send-email-dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 07:19:53PM +0400, Dmitry Eremin-Solenikov wrote:
> Include Makefile.lib into Makefile.fwinst to enable _shipped processing.

The mess in Makefile.lib is better not exposed too much.

I suggest to move the _shipped processing to Kbuild.include.

	Sam
