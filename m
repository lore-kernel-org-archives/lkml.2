Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0EYHpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:45:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:46105 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab0EYHpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:45:39 -0400
Date: Tue, 25 May 2010 09:45:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Stephane Chatty <chatty@enac.fr>, wylda@volny.cz,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, Jerome Vidal <jerom3@free.fr>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] HID: add chardev to propagate special events of
 Roccat hardware to userland
In-Reply-To: <1274288116.2248.3.camel@localhost>
Message-ID: <alpine.LNX.2.00.1005250944580.28092@pobox.suse.cz>
References: <1274288116.2248.3.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, Stefan Achatz wrote:

> Module roccat is a char device used to report special events of roccat
> hardware to userland. 

I have now applied it.

It would be also nice if you could provide a link to the userspace 
software taking care of these special events somewhere.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
