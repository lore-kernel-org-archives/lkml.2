Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab1AaUew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:34:52 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:38787 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab1AaUev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:34:51 -0500
Date: Mon, 31 Jan 2011 21:34:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, jwboyer@linux.vnet.ibm.com,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/3] dt: documentation reorganization
Message-ID: <20110131203449.GA4199@merkur.ravnborg.org>
References: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 12:44:41AM -0700, Grant Likely wrote:
> This series reorganizes and cleans up the device tree documentation
> to make the directory useful for non-powerpc users.

Looks better than first try. But the structure is very flat.
Did you consider an arch/* for all arch specific stuff?

	Sam
