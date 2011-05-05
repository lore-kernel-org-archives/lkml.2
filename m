Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1EEUol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:44:41 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14240 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab1EEUok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:44:40 -0400
Date: Thu, 5 May 2011 22:37:53 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: J Freyensee <james_p_freyensee@linux.intel.com>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 3/4] Intel PTI implementaiton of MIPI 1149.7.
In-Reply-To: <1304615163.8860.58.camel@localhost>
Message-ID: <alpine.LNX.2.00.1105052236360.894@swampdragon.chaosbits.net>
References: <james_p_freyensee@linux.intel.com>  <1303515150-1718-4-git-send-email-james_p_freyensee@linux.intel.com>  <alpine.LNX.2.00.1104240212390.28014@swampdragon.chaosbits.net>  <alpine.LNX.2.00.1104240306570.28014@swampdragon.chaosbits.net>
 <1304615163.8860.58.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, J Freyensee wrote:

[...]
> 
> I'm no means an expert in the kernel, but I assume kfree() is like C
> free(), that it's a nop if it receives a NULL value?
> 

Yes. kfree(NULL) is a nop, so you can avoid the conditional branch.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

