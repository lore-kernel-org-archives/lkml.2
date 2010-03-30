Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab0C3GJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:09:32 -0400
Received: from mail.perches.com ([173.55.12.10]:1252 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab0C3GJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:09:31 -0400
Subject: Re: [PATCH] fs/cifs: Neaten cERROR and cFYI macros, reduce text
 space  ~2.5K
From: Joe Perches <joe@perches.com>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs-client@lists.samba.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <524f69651003292223t229cfb59xedf8bdb4bdb45102@mail.gmail.com>
References: <1268778571.1652.8.camel@Joe-Laptop.home>
	 <524f69651003162020v43b7d9cfh5b409fc1a4d0f716@mail.gmail.com>
	 <524f69651003292223t229cfb59xedf8bdb4bdb45102@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 23:09:29 -0700
Message-ID: <1269929369.4558.107.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 00:23 -0500, Steve French wrote:
> Merged the equivalent into smb2.git

Thanks.

> Due to its large size, would prefer to wait on the cifs version of
> this until next merge window.

Makes sense to me.
I presume these changes for both smb2 and cifs are for 2.6.35.

