Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab1C2Fyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 01:54:40 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:55873 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1C2Fyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 01:54:39 -0400
Date: Tue, 29 Mar 2011 14:54:34 +0900
From: Simon Horman <horms@verge.net.au>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NOMMU: implement access_remote_vm
Message-ID: <20110329055434.GA10227@verge.net.au>
References: <1301085148-14860-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301085148-14860-1-git-send-email-vapier@gentoo.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 04:32:28PM -0400, Mike Frysinger wrote:
> Recent vm changes brought in a new function which the core procfs code
> utilizes.  So implement it for nommu systems too to avoid link failures.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

This resolves a build problem that I observed this afternoon.

Drive-by Tested-by: Simon Horman <horms@verge.net.au>

