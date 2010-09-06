Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0IFTva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 15:51:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42881 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0IFTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 15:51:25 -0400
Date: Mon, 6 Sep 2010 15:51:08 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Tejun Heo <tj@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, jgarzik@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: libata acpi issue on gateway laptop
Message-ID: <20100906195108.GN2684@bombadil.infradead.org>
References: <20100906193501.GM2684@bombadil.infradead.org>
 <4C854502.8040009@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C854502.8040009@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 09:46:10PM +0200, Tejun Heo wrote:
> These are debug/info messages.  Just ignore them.
> 

The user claims they are causing long delays waiting for the timeouts to
occur that go away if booting with noacpi...

--Kyle
