Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1JSUHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 16:07:00 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37224 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296Ab1JSUG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 16:06:58 -0400
Subject: Re: Please include const-sections into linux-next
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <1319054693.3034.49.camel@dabdike.int.hansenpartnership.com>
References: <20111013233818.GB26654@one.firstfloor.org>
	 <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
	 <20111016033514.GC26654@one.firstfloor.org>
	 <1318799006.2995.1.camel@dabdike.int.hansenpartnership.com>
	 <0e9ef9174a0089187fde0b3d084672ad.squirrel@www.firstfloor.org>
	 <1319039663.3034.18.camel@dabdike.int.hansenpartnership.com>
	 <20111019161537.GH15908@one.firstfloor.org>
	 <1319041281.3034.25.camel@dabdike.int.hansenpartnership.com>
	 <20111019163351.GJ15908@one.firstfloor.org>
	 <1319050557.3034.46.camel@dabdike.int.hansenpartnership.com>
	 <20111019190517.GK15908@one.firstfloor.org>
	 <1319054693.3034.49.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Oct 2011 15:06:56 -0500
Message-ID: <1319054816.3034.50.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-19 at 15:04 -0500, James Bottomley wrote:
> this is probably something to do with writeable strings?

Bingo!  If I add -fno-writeable-strings to the compiler directives, it
works.

James


