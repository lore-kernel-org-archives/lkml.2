Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab0FDA6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 20:58:00 -0400
Received: from tundra.namei.org ([65.99.196.166]:41199 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab0FDA56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 20:57:58 -0400
Date: Fri, 4 Jun 2010 10:57:51 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Shaz <shazalive@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       securityengineeringresearchgroup 
	<securityengineeringresearchgroup@googlegroups.com>
Subject: Re: [PATCH 00/14] EVM
In-Reply-To: <1275420536.28134.37.camel@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1006041052450.1003@tundra.namei.org>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>  <alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>  <AANLkTil8LHjRT_PMosymmtBb1pxIzkBaWC0ef35DCBUU@mail.gmail.com>  <AANLkTil7WvVZ-3zpA0E--fUcHTqul3pnXnPm1xXn_vlH@mail.gmail.com>
 <1275420536.28134.37.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, Mimi Zohar wrote:

> SELinux, Smack, Capabilities, and IMA all use extended attributes. The
> purpose of EVM is to detect offline tampering of these security extended
> attributes.

One issue mentioned to me off-list is that if EVM is only protecting 
against offline attacks, why not just encrypt the entire volume ?

This would provide confidentiality and integrity protection for all data 
and metadata, rather than just integrity for xattr metadata.


- James
-- 
James Morris
<jmorris@namei.org>
