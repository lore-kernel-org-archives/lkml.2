Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab0GUXud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 19:50:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63675 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab0GUXua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 19:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xJDQpYPJjQwQXSYAvFp3hIDdN5X+L8H+81RI/WeB5mx44n6cEcKggKRVqsLpsxe/tR
         3Q2j1OKl3RgGClD7J2CcnuyagkE5mP3GO/2t/yf4QZZweXW4kaG23AkiWV5mfWiqGgHR
         UOn4ntbr8Gf3MCAUX6echEpfn2UOw4SvH5Ws4=
Date: Thu, 22 Jul 2010 01:50:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/18] raw: use explicit llseek file operations
Message-ID: <20100721235025.GB5801@nowhere>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278538820-1392-13-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278538820-1392-13-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 11:40:14PM +0200, Arnd Bergmann wrote:
> The raw_fops may need to seek, so there should
> be an explicit reference to default_llseek.
> raw_ctl_fops does not contain a read or write
> method, so we use noop_llseek to ignore seeking
> requests without an error.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>



Applied in a new branch: bkl/llseek, I will propose it for
-next soon.

Thanks.

