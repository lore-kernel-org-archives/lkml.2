Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1HKIOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:14:04 -0400
Received: from tundra.namei.org ([65.99.196.166]:48421 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab1HKIOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:14:01 -0400
Date: Thu, 11 Aug 2011 18:13:54 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 2/2] evm: fix evm_inode_init_security return code
In-Reply-To: <1313036572-27122-2-git-send-email-zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1108111813330.5490@tundra.namei.org>
References: <1313036572-27122-1-git-send-email-zohar@linux.vnet.ibm.com> <1313036572-27122-2-git-send-email-zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both applied, still seeing this problem:

http://marc.info/?l=linux-kernel&m=131293882430148&w=2



-- 
James Morris
<jmorris@namei.org>
