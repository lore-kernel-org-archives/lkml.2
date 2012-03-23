Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab2CWPWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 11:22:52 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51245 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab2CWPWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 11:22:50 -0400
Message-ID: <4F6C9547.4060509@pobox.com>
Date: Fri, 23 Mar 2012 11:22:47 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
References: <20120323130031.c097ca3755de5ff5879504e1@canb.auug.org.au> <1332478202.2882.2.camel@pasglop> <1332490486.2801.1.camel@dabdike.int.hansenpartnership.com> <1332492832.2882.4.camel@pasglop> <1332493291.2801.14.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1332493291.2801.14.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 05:01 AM, James Bottomley wrote:
> Yes, sorry ... it's one of those large all or nothing type series that
> touches about 33 different drivers (about 75% of which are
> unmaintained).

To be more specific, it was a patch series that was never CC'd to ANY 
driver author, nor linux-ide, nor LKML.

	Jeff


