Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0C3WXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:23:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58899 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0C3WXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:23:05 -0400
Date: Tue, 30 Mar 2010 23:23:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Juraj Hlista <juro.hlista@gmail.com>
Cc: sgrubb@redhat.com, mitr@redhat.com, linux-kernel@vger.kernel.org,
       linux-audit@redhat.com
Subject: Re: [PATCH] audit: Reactive rules
Message-ID: <20100330222302.GK30031@ZenIV.linux.org.uk>
References: <alpine.LNX.2.00.1003310009440.30178@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1003310009440.30178@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 12:17:11AM +0200, Juraj Hlista wrote:
> From: Juraj Hlista <juro.hlista@gmail.com>
> 
> Add support for reactive rules. An audit rule can contain more than one reaction. The reactions are identified by numbers in the kernel and by strings in the user space.

Huh?  We already have a way to associate a unique key with a rule; what does
that patch offer that can't be happily handled by userland with what we
already have?
