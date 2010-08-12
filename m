Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741Ab0HLSV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 14:21:28 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49824 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0HLSVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 14:21:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x1FAmfWaf+5wYo/4JG/aCo6seDXPMQbXJ1Xmdbwvne3O6fQhQWuMwEs+uRvKCz56i7
         6lRX9Rfihzx7GFIi7jYm55c25p1KsyM8Ms2wqeKpw5pSQ/IYtSbUeN4B6UkHW9Fzag/J
         r+Veo63EQYs6GO5aiMdT6jBksjJN3xDcrVLAQ=
MIME-Version: 1.0
In-Reply-To: <20100812174621.b1dbc20f.sfr@canb.auug.org.au>
References: <20100812131741.f3a800d7.sfr@canb.auug.org.au>
	<AANLkTi=iHi=kpk+nsB396B9GWdefj=WJywA2K1PawHxi@mail.gmail.com>
	<20100812174621.b1dbc20f.sfr@canb.auug.org.au>
Date: Thu, 12 Aug 2010 13:21:22 -0500
Message-ID: <AANLkTi=bAGSrPbqmOUbt9O7G0SbOXYTtNDYZ-e5JPsrS@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
From: Steve French <smfrench@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
        Bryan Schumaker <bjschuma@netapp.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 2:46 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> See above.  You need CONFIG_NFS_USE_KERNEL_DNS to also depend on
> CONFIG_KEYS ...

Fixed in cifs-2.6.git


-- 
Thanks,

Steve
