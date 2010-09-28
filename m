Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab0I1S2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 14:28:50 -0400
Received: from kroah.org ([198.145.64.141]:46599 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757661Ab0I1S2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 14:28:48 -0400
Date: Tue, 28 Sep 2010 11:29:33 -0700
From: Greg KH <greg@kroah.com>
To: James Dingwall <james.dingwall@amdocs.com>
Cc: Kyle McMartin <kmcmartin@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "james@dingwall.me.uk" <james@dingwall.me.uk>
Subject: Re: [stable] PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just
	after the boot [PATCH]
Message-ID: <20100928182933.GB32464@kroah.com>
References: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com> <20100927024044.GQ13116@bombadil.infradead.org> <20100927061336.GA22721@kroah.com> <20100927063405.GM19458@ihatethathostname.lab.bos.redhat.com> <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475979@UKLNDMAIL1.corp.amdocs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475979@UKLNDMAIL1.corp.amdocs.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 09:37:17AM +0100, James Dingwall wrote:
> My first contribution so I hope I didn't miss any important steps in
> formatting the patch and that Outlook keeps it intact...  If it needs
> any fixing up let me know.

Looks good, I've now queued it up, thanks so much for this.

greg k-h
