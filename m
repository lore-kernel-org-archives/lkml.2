Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab0EaAUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 20:20:31 -0400
Received: from tundra.namei.org ([65.99.196.166]:50924 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0EaAUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 20:20:30 -0400
Date: Mon, 31 May 2010 10:20:22 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 00/14] EVM
In-Reply-To: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1005311017530.24571@tundra.namei.org>
References: <1271886594-3719-1-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010, Mimi Zohar wrote:

> Much appreciation to Dave Hansen, Serge Hallyn, and Matt Helsley for
> reviewing the patches.

We're not seeing much comment on this code beyond the folk above.  It 
might help to cc fsdevel.

Also, I raised some issues:

  I'd also be interested to know what kind of user demand there is for EVM 
  -- are there any specific instances of user requirements which are met 
  by it?  Do any distros plan to enable and support it?

and does this code meet the requirements of potential users such as Meego ?



- James
-- 
James Morris
<jmorris@namei.org>
