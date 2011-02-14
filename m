Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab1BNX3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:29:04 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12940 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1BNX27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:28:59 -0500
Date: Tue, 15 Feb 2011 00:27:55 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Fix numbering of KVM API description
 sections
In-Reply-To: <1297725770.1793.40.camel@t41.thuisdomein>
Message-ID: <alpine.LNX.2.00.1102150026130.4530@swampdragon.chaosbits.net>
References: <1297724884.1793.38.camel@t41.thuisdomein>  <alpine.LNX.2.00.1102150016040.4530@swampdragon.chaosbits.net> <1297725770.1793.40.camel@t41.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Paul Bolle wrote:

> On Tue, 2011-02-15 at 00:17 +0100, Jesper Juhl wrote:
> > Yup. Duplicate section numbers for "4.6 KVM_SET_MEMORY_REGION" & "4.6 KVM_CREATE_VCPU".
> 
> There are also two sections 4.27, and section 4.31 is missing.
> 
It all starts with the duplicate 4.6 ;) I checked the end result and saw 
that it was as it should be, so added the reviewed-by. Didn't bother 
commenting on all details

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

