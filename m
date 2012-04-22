Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab2DVGDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 02:03:18 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:44200 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2DVGDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 02:03:14 -0400
Date: Sun, 22 Apr 2012 08:03:12 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix modpost failures in fedora 17
Message-ID: <20120422060312.GA5701@merkur.ravnborg.org>
References: <20120412.143730.258982831585270742.davem@davemloft.net> <20120418.153132.547432135869114399.davem@davemloft.net> <20120422.001844.812968677385216602.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120422.001844.812968677385216602.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 12:18:44AM -0400, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 18 Apr 2012 15:31:32 -0400 (EDT)
> 
> > Ping?  Can we get this bug fixed merged some time soon?
> 
> Come on guys, this should be in Linus's tree and submitted to
> all -stable branches by now.  Yet it hasn't been submitted to
> any of those places.
> 
> What in the world could you possibly be waiting for?

Added Michal + kbuild. I do nto handle kbuild patches these days.

	Sam
