Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0LFPmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:42:09 -0500
Received: from smtprelay03.ispgateway.de ([80.67.29.7]:42835 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0LFPmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:42:08 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2010 10:42:08 EST
Message-ID: <20101206163506.56232lqqhc5c3co4@webmail.df.eu>
Date: Mon, 06 Dec 2010 16:35:06 +0100
From: Bernhard Walle <bernhard@bwalle.de>
To: Jeff Layton <jlayton@redhat.com>
Cc: Jeff Layton <jlayton@samba.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Add information about noserverino
References: <1291568855-22604-1-git-send-email-bernhard@bwalle.de>
 <20101206095725.78422138@tlielax.poochiereds.net>
 <20101206101214.52a24415@tlielax.poochiereds.net>
In-Reply-To: <20101206101214.52a24415@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.2)
X-Originating-IP: 212.114.252.242
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zitat von Jeff Layton <jlayton@redhat.com>:

>
> I'm still not sure I like this patch however. It potentially means a
> lot of printk spam since these things have no ratelimiting. It also
> doesn't tell me anything about which server might be giving me grief.
>
> Maybe this should be turned into a cFYI?

Well, if I see it in the kernel log, it doesn't matter if it's info or
something else.

> The bottom line though is that running 32-bit applications that were
> built without -D_FILE_OFFSET_BITS=64 on a 64-bit kernel is a very bad
> idea. It would be nice to be able to alert users that things aren't
> working the way they expect, but I'm not sure this is the right place
> to do that.

Well, but there *are* such application (in my case it was Softmaker Office
which is a proprietary word processor) and it's quite nice if you know
how you can workaround it when you encounter such a problem. That's all.


Regards,
Bernhard


