Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1CDH3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 02:29:25 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:60390 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1CDH3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 02:29:24 -0500
Date: Fri, 4 Mar 2011 15:29:20 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Sterba <dsterba@suse.cz>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: do not attempt to write to readonly variable
Message-ID: <20110304072920.GA9973@gondor.apana.org.au>
References: <1298298442-24697-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1298298442-24697-1-git-send-email-dsterba@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 03:27:22PM +0100, David Sterba wrote:
> Commit da7f033ddc9fdeb (”crypto: cryptomgr - Add test infrastructure”) added a
> const to variable which is later used as target buffer of memcpy.

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
