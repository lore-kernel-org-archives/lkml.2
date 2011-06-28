Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1F1XTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:19:15 -0400
Received: from tundra.namei.org ([65.99.196.166]:44971 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab1F1XTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:19:09 -0400
Date: Wed, 29 Jun 2011 09:19:05 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Greg KH <greg@kroah.com>
cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/2] AppArmor: Fix masking of capabilities in complain
 mode
In-Reply-To: <20110628181215.GA15843@kroah.com>
Message-ID: <alpine.LRH.2.00.1106290918250.14211@tundra.namei.org>
References: <1309276565-20776-1-git-send-email-john.johansen@canonical.com> <1309276565-20776-3-git-send-email-john.johansen@canonical.com> <20110628181215.GA15843@kroah.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011, Greg KH wrote:

> As this should probably go to the stable tree, next time care to add a
> simple:
> 	Cc: stable <stable@kernel.org>
> to the signed-off-by: area of the patch so it gets automagically
> included in the stable and longterm kernels as needed when it hits
> Linus's tree?
> 

JJ, I'll wait for you to respin these before pulling them.

-- 
James Morris <jmorris@namei.org>
