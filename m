Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0KHSU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:20:29 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:43927 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0KHSU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:20:27 -0500
Subject: Re: [PATCH v1.2 3/4] keys: add new trusted key-type
From: David Safford <safford@watson.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20101108170937.GA31501@obsidianresearch.com>
References: <1289230246-3856-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289230246-3856-4-git-send-email-zohar@linux.vnet.ibm.com>
	 <20101108170937.GA31501@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 08 Nov 2010 13:18:33 -0500
Message-ID: <1289240313.6060.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 10:09 -0700, Jason Gunthorpe wrote:
> On Mon, Nov 08, 2010 at 10:30:45AM -0500, Mimi Zohar wrote:
> 
> > pcrlock=n    extends the designated PCR 'n' with a random value,
> >              so that a key sealed to that PCR may not be unsealed
> >              again until after a reboot.
> 
> Nice, but this seems very strange to me, since it has nothing to do
> with the key and could be done easially in userspace?
> 
> Jason

This is strictly for convenience in initramfs, so that the trusted
key can be loaded and locked in a single command, with no need for
an additional application to extend a PCR. As the the TPM driver 
already has support for extend, it's a trivial addition.

dave
