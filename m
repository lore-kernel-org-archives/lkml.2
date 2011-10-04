Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab1JDP0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:26:37 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53355 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932513Ab1JDP0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:26:33 -0400
X-Sasl-enc: fZO1wfL3aLXJlkP1IOWdcZhGlRKeEawJ6qm+1YHDT+NF 1317741992
Date: Tue, 4 Oct 2011 08:25:22 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eliad Peller <eliad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the staging tree with the net and
 wireless trees
Message-ID: <20111004152522.GA29994@kroah.com>
References: <20111004171449.de5c45332510a453cc3ff879@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004171449.de5c45332510a453cc3ff879@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 05:14:49PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/brcm80211/brcmsmac/mac80211_if.c between commit
> 37a41b4affa3 ("mac80211: add ieee80211_vif param to tsf functions") from
> the net tree, commit 8a3a3c85e44d ("mac80211: pass vif param to conf_tx()
> callback") from the wireless tree and several commits from the staging
> tree.
> 
> I fixed it up (just removed the forward declarions that were changed by
> the former commits) and can carry the fix as necessary.

Thanks, that sounds correct.

Aren't you happy my trees are back now?  :)

greg k-h
