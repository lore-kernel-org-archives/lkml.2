Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab1EQVsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:48:45 -0400
Received: from outmail005.snc4.facebook.com ([66.220.144.137]:39174 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932476Ab1EQVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:48:44 -0400
Date: Tue, 17 May 2011 14:48:43 -0700
From: Arun Sharma <asharma@fb.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Arun Sharma <asharma@fb.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] kbuild: Integrate with new-kernel-pkg
Message-ID: <20110517214843.GA6452@dev1756.snc6.facebook.com>
References: <1305653779-3445-1-git-send-email-asharma@fb.com>
 <4DD2D0B3.4070208@suse.cz>
 <20110517204520.GA21201@dev1756.snc6.facebook.com>
 <4DD2E9D9.7030207@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD2E9D9.7030207@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 11:34:17PM +0200, Michal Marek wrote:
> > and have similar stanzas for other popular rpm based distros.
> 
> Or use /sbin/installkernel and let distros handle it.

There is no /sbin/uninstallkernel though :)

Also installkernel doesn't seem to have a way of making the 
newly installed rpm the default kernel.

I'm ok with either approach (go with the least common denominator
or have parallel distro specific code).

 -Arun
