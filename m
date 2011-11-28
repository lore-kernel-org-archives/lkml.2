Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1K1Mrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:47:53 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:56172 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1K1Mrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:47:51 -0500
Date: Mon, 28 Nov 2011 20:47:19 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Olaf Hering <olaf@aepfle.de>, linux-crypto@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 08/62] x86: remove the second argument of
	k[un]map_atomic()
Message-ID: <20111128124719.GA16828@gondor.apana.org.au>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-9-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322371662-26166-9-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 01:26:48PM +0800, Cong Wang wrote:
> 
> Signed-off-by: Cong Wang <amwang@redhat.com>

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
