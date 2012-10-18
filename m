Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2JRTlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:41:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58278 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2JRTlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:41:07 -0400
Date: Thu, 18 Oct 2012 12:40:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dynamic_debug: Remove unnecessary __used
Message-ID: <20121018194027.GA1246@kroah.com>
References: <1350587223.5652.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350587223.5652.4.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 12:07:03PM -0700, Joe Perches wrote:
> The __used attribute prevents gcc from eliminating
> unnecessary, otherwise optimized away, metadata for
> debugging logging messages.
> 
> Remove the __used attribute.

Very cool.  Any idea how much space this saves?

greg k-h
