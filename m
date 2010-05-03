Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753Ab0ECWPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:15:13 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37728 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758388Ab0ECWPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:15:10 -0400
Date: Mon, 3 May 2010 17:14:55 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, keyrings@linux-nfs.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] KEYS: find_keyring_by_name() can gain access to a
 freed keyring
Message-ID: <20100503221455.GB6968@us.ibm.com>
References: <20100430133208.2126.56765.stgit@warthog.procyon.org.uk>
 <20100430133213.2126.63908.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100430133213.2126.63908.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Reported-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Tested-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

(looks good, fwiw)

Acked-by: Serge Hallyn <serue@us.ibm.com>
