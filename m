Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab0ENRDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 13:03:15 -0400
Received: from lazybastard.de ([212.112.238.170]:36332 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab0ENRDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 13:03:14 -0400
Date: Fri, 14 May 2010 19:03:03 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kirjanov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib/btree: Kill unused MAX macro
Message-ID: <20100514170303.GA32417@logfs.org>
References: <20100512211724.GA5507@coldcone> <20100513132434.3b1515fa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100513132434.3b1515fa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 13:24:34 -0700, Andrew Morton wrote:
> 
> Also, this reader is quite unable to determine why this forumation for
> NODESIZE was chosen.  As few kernel programmers can read Joern's mind,
> I'd suggest that a code comment is in order.

Ack.  I'm currently on vacation, so it will have to wait until next
week.

Jörn

-- 
Unless something dramatically changes, by 2015 we'll be largely
wondering what all the fuss surrounding Linux was really about.
-- Rob Enderle
