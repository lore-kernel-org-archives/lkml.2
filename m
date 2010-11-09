Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab0KIQcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:32:10 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:57947 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0KIQcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:32:08 -0500
Subject: Re: [PATCH v1.2 3/4] keys: add new trusted key-type
From: David Safford <safford@watson.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <201011091702.58449.roberto.sassu@polito.it>
References: <1289230246-3856-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20101109064016.GF16307@obsidianresearch.com>
	 <1289315838.16976.38.camel@localhost.localdomain>
	 <201011091702.58449.roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Nov 2010 11:25:10 -0500
Message-ID: <1289319910.16976.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 17:02 +0100, Roberto Sassu wrote:

> i want to inform you i've created a set of utilities for the creation of
> trusted and encrypted keys which also works with the TrustedGRUB software:
> for instance the new "trk_create" tool generates or updates a trusted key
> passing the pcrinfo structure relative to the future configuration
> by performing the same extend operations done by TrustedGRUB during the
> boot process:
...
> I have tested these tools using the Fedora 13 operating system and they may be of interest
> if the TrustedGRUB part is not yet implemented by your tools. 
> 
> Roberto

My tools don't yet do the future boot pcr calculation,
so this is wonderful. Are they available?

dave

