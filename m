Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab1DYWos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 18:44:48 -0400
Received: from 1wt.eu ([62.212.114.60]:34830 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab1DYWor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 18:44:47 -0400
Date: Tue, 26 Apr 2011 00:44:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, stable-review@kernel.org,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [stable] [PATCH 054/173] acer-wmi: Fix capitalisation of GUID
Message-ID: <20110425224433.GB13048@1wt.eu>
References: <20110425200235.342580584@pcw.home.local> <201104252300.14068.carlos@strangeworlds.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104252300.14068.carlos@strangeworlds.co.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 11:00:13PM +0100, Carlos Corbacho wrote:
> On Monday 25 Apr 2011 21:03:26 Willy Tarreau wrote:
> > 2.6.27.59-stable review patch.  If anyone has any objections, please let us
> > know.
> 
> Nack - this caused https://bugzilla.kernel.org/show_bug.cgi?id=32862
> 
> Either don't apply this patch, or you'll need to also apply the subsequent fix 
> up at the same time (I don't know if that's gone upstream yet?).

Fine, I've removed it.

Thank you Carlos!
Willy

