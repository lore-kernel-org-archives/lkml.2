Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0LUVWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:22:30 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41193 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab0LUVW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:22:29 -0500
Date: Tue, 21 Dec 2010 16:22:28 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] flexcop: kill a WARN_ON in xlate_proc_name
Message-ID: <20101221212228.GF15129@bombadil.infradead.org>
References: <20100903204446.GJ2684@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903204446.GJ2684@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 04:44:46PM -0400, Kyle McMartin wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> The flexcop driver is currently trying to register DRIVER_NAME for its
> irq name. Use a less braindead name (the module name) to
>  1) avoid a warning in xlate_proc_name
>  2) have a nice entry in /proc/irq/$n/
> 
> (https://bugzilla.redhat.com/show_bug.cgi?id=575873)
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

ping?
