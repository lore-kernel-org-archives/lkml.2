Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2KIPzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:55:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab2KIPz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:55:29 -0500
Date: Fri, 9 Nov 2012 10:55:21 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH cifs-next] fs: cifs: make smb_echo_interval tunable
Message-ID: <20121109105521.00f3c291@tlielax.poochiereds.net>
In-Reply-To: <509D23F5.3080107@canonical.com>
References: <1352407828-23339-1-git-send-email-chris.j.arges@canonical.com>
	<20121109060017.63811198@tlielax.poochiereds.net>
	<509D23F5.3080107@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Nov 2012 09:40:37 -0600
Chris J Arges <chris.j.arges@canonical.com> wrote:

> > 
> > I'm not so sure I like making this tunable...
> > 
> Ok, I saw the 'FIXME: tunable?', and thought this was something that
> could be exposed as a parameter in the future.
> 

Yeah, when I originally wrote that code I put that comment in. Since
then I think we've figured out more about how the echo facility in CIFS
should work. Making it tunable is not really a great solution. Having
the echoes better adapt to the situation would be preferable.

-- 
Jeff Layton <jlayton@redhat.com>
