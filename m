Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab0GUX7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 19:59:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52782 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076Ab0GUX7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 19:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l+HSON22FHX/t36c7FJWr42/QtYNrtrXCSeOM4Vv/yNMh2noqTFOwO1wfKKRZmkPeN
         C0CmxOUYg/QXx7dR3lIQT6h1YIr81/k26dYok1W1cQDJkTimVujQZdKuosAitJT4hFsX
         sPVrijLhDxGQJnqanPsqZmCpOErnMLfOWyWUs=
Date: Thu, 22 Jul 2010 01:59:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/18] viotape: use noop_llseek
Message-ID: <20100721235947.GD5801@nowhere>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278538820-1392-16-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278538820-1392-16-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 11:40:17PM +0200, Arnd Bergmann wrote:
> Some applications try to seek on tape devices
> and fail if they return an error. Since we
> want to change the default llseek action to
> no_llseek, viotape needs to be changed to use
> noop_llseek explicitly.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>


Applied, thanks.

