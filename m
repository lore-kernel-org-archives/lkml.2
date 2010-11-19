Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0KSQFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:05:30 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:33952 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab0KSQF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:05:27 -0500
Subject: Re: [PATCH v1.4 3/5] key: add tpm_send command
From: David Safford <safford@watson.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@watson.ibm.com>
In-Reply-To: <9837.1290181537@redhat.com>
References: <1290120166-3132-4-git-send-email-zohar@linux.vnet.ibm.com>
	 <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <9837.1290181537@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 11:04:56 -0500
Message-ID: <1290182696.2597.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 15:45 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > +int tpm_send(u32 chip_num, void *cmd, int buflen)
> 
> I'd recommend size_t for buflen; apart from that:
> 
> Acked-by: David Howells <dhowells@redhat.com>

right - that would be better.

Currently transmit_command() in tpm.c expects an int,
but it changes it to size_t for the actual tpm_transmit().
We will work with Rajiv to do a cleanup, as this touches
a number of calls.

thanks!
dave
