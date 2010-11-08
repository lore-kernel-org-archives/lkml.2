Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0KHMXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 07:23:43 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:61094 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab0KHMXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 07:23:42 -0500
Subject: Re: [PATCH RFC] Restrictions on module loading
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, security@kernel.org
In-Reply-To: <20101108102013.0861725b@lxorguk.ukuu.org.uk>
References: <1289179439.3090.205.camel@Dan>
	 <20101108102013.0861725b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 07:23:36 -0500
Message-ID: <1289219016.10229.14.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> NAK - Its a long standing ABI.

As far as I can tell, modules_disabled was first included in 2.6.31, so
it's hardly what I'd call "long standing".  However, I see your point -
it's definitely not my intention to surprise anyone by changing security
features out from under them.

I do think merging the features makes sense in this case.  I'll rework
this to keep the "modules_disabled" name, where a value of "0" means
default behavior, a value of "1" means no loading or unloading (and no
changing it back), and the new value of "2" incorporates the
restrictions I'm intending to enforce.

> 
> I've no objection to modules_restrict although I doubt it'll ever get
> used in the real world, but better to extend the meaning of the existing
> interface, not remove stuff.
> 

There has been interest in improving the ease with which users can
enforce restrictions on automatic module loading.  No one is being
forced to use it.

-Dan


