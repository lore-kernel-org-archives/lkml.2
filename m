Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab1CPDiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 23:38:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42208 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1CPDiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 23:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wTE1wH7+Wpt5DiLnVzm+RfSuCRNiJxkvqg2gV7UCJNwmQr60aqMTOQQ4dX69os4x8Z
         DmarFJ3oieEMFjKTxiCKS2CqRamQtxw5Ou3WayVNJVhOOaw3sMezc65O6CFW+3sQ0w3/
         EsxQc0UMz5zuIHwiWTYHc/P1vU4PhtYKf4lkY=
MIME-Version: 1.0
In-Reply-To: <20110315172208.82934b13.randy.dunlap@oracle.com>
References: <20110315194543.a5d56c0c.sfr@canb.auug.org.au>
	<20110315172208.82934b13.randy.dunlap@oracle.com>
Date: Wed, 16 Mar 2011 11:38:03 +0800
Message-ID: <AANLkTi=yDHaeosLpyuCjTJ8hZA8Q4bzHCmKK0J1Giunz@mail.gmail.com>
Subject: Re: [PATCH -next] uml: fix tty interface warnings
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 8:22 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix tty interface warnings in arch/um:
>
> arch/um/drivers/stdio_console.c:122: warning: initialization from incompatible pointer type
> arch/um/drivers/ssl.c:139: warning: initialization from incompatible pointer type
>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.
