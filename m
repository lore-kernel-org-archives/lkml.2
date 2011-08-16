Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1HPBEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 21:04:10 -0400
Received: from tundra.namei.org ([65.99.196.166]:56179 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab1HPBEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 21:04:08 -0400
Date: Tue, 16 Aug 2011 11:03:58 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
cc: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: Re: [RFC v1.1 3/5] evm: digital signature support
In-Reply-To: <d6ca3779df5a812a1b838b0a707a994a341846ed.1313082284.git.dmitry.kasatkin@intel.com>
Message-ID: <alpine.LRH.2.00.1108161103020.7706@tundra.namei.org>
References: <cover.1313082284.git.dmitry.kasatkin@intel.com> <d6ca3779df5a812a1b838b0a707a994a341846ed.1313082284.git.dmitry.kasatkin@intel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Aug 2011, Dmitry Kasatkin wrote:

> From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> 
> When building an image, which has to be flashed to different devices,
> an HMAC cannot be used to sign file metadata, as the HMAC key is different
> on every device. File metadata can be protected using digital signature.
> This patch enables RSA signature based integrity verification.

This description (also the kconfig text) is not very clear.  Perhaps start 
with what the feature does rather than what the lack of it doesn't.



-- 
James Morris
<jmorris@namei.org>
