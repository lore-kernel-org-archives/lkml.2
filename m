Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab2DEGBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:01:54 -0400
Received: from ka.mail.enyo.de ([87.106.162.201]:32804 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab2DEGBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:01:53 -0400
From: Florian Weimer <fw@deneb.enyo.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Martin Lucina <martin@lucina.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Implement IP_EVIL socket option (RFC 3514)
References: <1333284791-5363-1-git-send-email-martin@lucina.net>
	<87r4w3nw7n.fsf@mid.deneb.enyo.de>
	<20120404201821.GC6589@ZenIV.linux.org.uk>
Date: Thu, 05 Apr 2012 08:01:49 +0200
In-Reply-To: <20120404201821.GC6589@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 4 Apr 2012 21:18:21 +0100")
Message-ID: <874nsyk982.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Al Viro:

> On Wed, Apr 04, 2012 at 09:17:00PM +0200, Florian Weimer wrote:
>> * Martin Lucina:
>> 
>> > This patch implements the IP_EVIL socket option, allowing user-space
>> > applications to set the Security Flag in the IPv4 Header, aka "evil" bit,
>> > as defined in RFC 3514.
>> 
>> I need this to fix a security issue.  Could this be merged for real,
>> please?
>
> I would suggest switching away from your RFC1149 link - looks like your mail
> took 3 days on the way out...

Sorry, I saw it just now.

The idea is to change the JVM to set IP_EVIL when an applet creates a
socket, so that this socket cannot be used to trick firewalls to open
up access to totally unrelated services.
