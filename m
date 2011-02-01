Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab1BAWJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:09:13 -0500
Received: from verein.lst.de ([213.95.11.210]:58033 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab1BAWJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:09:12 -0500
Date: Tue, 1 Feb 2011 23:08:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Christoph Hellwig <hch@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/4] hfsplus: Don't leak buffer on error
Message-ID: <20110201220857.GB23889@lst.de>
References: <20110201162802.2dd07201@katamari> <20110201164155.1a4c9ff6@katamari>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201164155.1a4c9ff6@katamari>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one looks good though, I'll put it in.

On Tue, Feb 01, 2011 at 04:41:55PM -0500, Chuck Ebbert wrote:
> hfsplus: Don't leak buffer on error

That's already said in the subject, no need to repeat it in the mail
body.

