Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0EQU45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 16:56:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656Ab0EQU44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 16:56:56 -0400
Date: Mon, 17 May 2010 13:54:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please pull logfs tree for fixes
In-Reply-To: <20100517171929.GC28003@logfs.org>
Message-ID: <alpine.LFD.2.00.1005171353400.4195@i5.linux-foundation.org>
References: <20100517171929.GC28003@logfs.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 May 2010, Jörn Engel wrote:
> 
> If such a situation reappears in the future, would you rather have the
> fixes and mindlessly revert them in case of any trouble or wait until
> the respective maintainer reappers?

Hmm. I think I'm happier this way. If there is something really critical 
for 2.6.34, you can always send it to stable.

		Linus
