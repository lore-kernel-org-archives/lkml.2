Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab1EBVTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:19:48 -0400
Received: from v020138.sys.capside.net ([81.25.117.138]:34480 "EHLO
	n023010.sys.capside.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab1EBVTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:19:32 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 17:19:32 EDT
Date: Mon, 2 May 2011 23:12:45 +0200
From: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, dgiagio@gmail.com, dborca@yahoo.com,
        pmcenery@gmail.com, david.hill@ubisoft.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ipheth.c: Enable IP header alignment
Message-ID: <20110502211245.GA18334@bart.evergreen.loc>
References: <1304264799.2833.82.camel@localhost>
 <1304364912-15444-1-git-send-email-agimenez@sysvalve.es>
 <20110502.124622.226785624.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110502.124622.226785624.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 12:46:22PM -0700, David Miller wrote:
> 
> Why did this break things?

Hi, I don't know. As upstream is unresponsive and is applying patches to his
private repo without submitting them to the list (which I can understand), I
decided to submit the particular fix so mainline users can get tethering working
again.

I received a forwarded email with the patch (I think that's because I submitted
the driver to mainline) asking for the mainline driver status and if it was
being maintained.

> 
> I'm not applying a fix when nobody can explain the reason why:
> 
> 1) Things broke in the first place
> 2) Forcing reservation of 2 bytes fixes things

Honestly, I can't answer either of those ones. I just submitted a patch that
*seemed* to fix the problem (I don't own an iPhone device since long time ago),
after explictly requesting upstream to submit by himself, and getting a
negative.


> Where is the built in assumption about "2" and why does it exist?  Why
> can't we fix this code not to have such assumptions in the first
> place?

Ditto.

At this point, I think that David, Diego or Daniel should step in if they want
to keep on with this discussion. I won't have problems if you want to take this
off-list.

Best regards,

-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1
