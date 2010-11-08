Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0KHRJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:09:51 -0500
Received: from quartz.orcorp.ca ([139.142.54.143]:40682 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab0KHRJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:09:50 -0500
Date: Mon, 8 Nov 2010 10:09:37 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH v1.2 3/4] keys: add new trusted key-type
Message-ID: <20101108170937.GA31501@obsidianresearch.com>
References: <1289230246-3856-1-git-send-email-zohar@linux.vnet.ibm.com> <1289230246-3856-4-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289230246-3856-4-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 10:30:45AM -0500, Mimi Zohar wrote:

> pcrlock=n    extends the designated PCR 'n' with a random value,
>              so that a key sealed to that PCR may not be unsealed
>              again until after a reboot.

Nice, but this seems very strange to me, since it has nothing to do
with the key and could be done easially in userspace?

Jason
