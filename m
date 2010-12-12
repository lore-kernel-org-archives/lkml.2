Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0LLTiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 14:38:06 -0500
Received: from torres.zugschlus.de ([85.214.131.164]:42772 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab0LLTiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 14:38:05 -0500
Date: Sun, 12 Dec 2010 20:38:03 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: Re: NetXen NX3031 failing test, reporting link down, not working
Message-ID: <20101212193803.GA28490@torres.zugschlus.de>
References: <20101206171727.GA30695@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101206171727.GA30695@torres.zugschlus.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 06:17:27PM +0100, Marc Haber wrote:
> I have HP DL 120 G6 with two Quad-GE Cards based on NetXen NX3031 (rev
> 42) [4040:0100]. The boxes are running with a grml daily image with
> kernel 2.6.36.1 for the time being, and the NetXens are giving me a
> hard time.
> 
> They work fine when I have two NetXens connected back-to-back (at
> least I can ping the other side), but they do not work when one of the
> NetXen Interfaces is connected to an HP ProCurve 2848.

Just for the record, the NetXens work fine even against a ProCurve
under Windows Server 2008 R2. This is thus a clear Linux issue.

I have filed bug #24792 in bugzilla. Is there anything more I can do
do pin down the issue (or to help pinning it down)?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
