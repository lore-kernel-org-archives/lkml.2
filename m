Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2LLImo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 03:42:44 -0500
Received: from 82-69-66-36.dsl.in-addr.zen.co.uk ([82.69.66.36]:65471 "EHLO
	gateway.l8s.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab2LLImn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 03:42:43 -0500
X-Greylist: delayed 1480 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2012 03:42:42 EST
Date: Wed, 12 Dec 2012 08:34:01 +0000
From: David Laight <david@l8s.co.uk>
To: Pavel Shilovsky <piastry@etersoft.ru>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, wine-devel@winehq.org
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Message-ID: <20121212083401.GW5010@snowdrop.l8s.co.uk>
Mail-Followup-To: Pavel Shilovsky <piastry@etersoft.ru>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	wine-devel@winehq.org
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru> <20121207161602.GA17710@infradead.org> <495d17310e0a687d446afc86def0f058@office.etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495d17310e0a687d446afc86def0f058@office.etersoft.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2012 at 12:43:14AM +0400, Pavel Shilovsky wrote:
> 
> The problem is the possibility of denial-of-service attacks here. We 
> can try to prevent them by:

FWIW I already see a DoS 'attack'.
I have some filestore shared using NFS (to Linux and Solaris) and 
using samba (to Windows).

I use it for release builds of a product to ensure the versions
built for the different operating systems match, and because some
files have to be built on an 'alien' system (eg gcc targetted at
embedded card).

I can't run the windows build at the same time as the others
because the windows C compiler manages to obtain exclusive access
to the source files - stopping the other systems from reading them.

	David

-- 
David Laight: david@l8s.co.uk
