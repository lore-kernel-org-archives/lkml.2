Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab0KKWX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:23:26 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53372 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897Ab0KKWXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:23:24 -0500
Subject: Re: [PATCH v1.3 1/4] lib: hex2bin converts ascii hexadecimal
 string to binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <6640.1289504927@redhat.com>
References: <1289404309-15955-2-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <6640.1289504927@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 17:23:21 -0500
Message-ID: <1289514201.2726.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 19:48 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > +void hex2bin(unsigned char *mem, char *buf, int count)
> 
> I think this needs a little adjustment.  I would recommend something like the
> following declaration:
> 
> 	void hex2bin(u8 *buf, const char *data, size_t count)
> 
> since the output data is binary (so use u8*), you're only reading the source
> data (so should use a const pointer) and you don't want to see a negative
> count (so use size_t).

right, thanks.

> Also, I'd suggest calling the source arg 'data' and the output arg 'buf' or
> maybe src/dst.
> 
> David

Definitely better. (Remnant from kgdb_hex2mem() naming.)

thanks,

Mimi


