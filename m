Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1ATVLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:11:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753Ab1ATVLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:11:22 -0500
Message-ID: <4D38A4F5.8070904@redhat.com>
Date: Thu, 20 Jan 2011 22:11:17 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chuck Lever <chuck.lever@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] NFS: Fix "kernel BUG at fs/nfs/nfs3xdr.c:1338!"
References: <20110120191639.3122.24837.stgit@matisse.1015granger.net>
In-Reply-To: <20110120191639.3122.24837.stgit@matisse.1015granger.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 08:18 PM, Chuck Lever wrote:
> Milan Broz <mbroz@redhat.com> reports:

>> [  105.327979] kernel BUG at fs/nfs/nfs3xdr.c:1338!

> 
> nfs3_xdr_enc_setacl3args() is not properly setting up the target
> buffer before nfsacl_encode() attempts to encode the ACL.
> 
> Introduced by commit d9c407b1 "NFS: Introduce new-style XDR encoding
> functions for NFSv3."

Yes, patch fixes the problem for me.

Thanks,
Milan
