Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab0LYQge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 11:36:34 -0500
Received: from torres.zugschlus.de ([85.214.131.164]:41488 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab0LYQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 11:36:34 -0500
Date: Sat, 25 Dec 2010 17:36:32 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: Re: NetXen NX3031 failing test, reporting link down, not working
Message-ID: <20101225163632.GA27786@torres.zugschlus.de>
References: <20101206171727.GA30695@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101206171727.GA30695@torres.zugschlus.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 06, 2010 at 06:17:27PM +0100, Marc Haber wrote:
> I have HP DL 120 G6 with two Quad-GE Cards based on NetXen NX3031 (rev
> 42) [4040:0100]. The boxes are running with a grml daily image with
> kernel 2.6.36.1 for the time being, and the NetXens are giving me a
> hard time.

it's a pity that nobody cared to even point me into the right
direction. I am not aware of having done anything wrong.

Anyway, the issue could be solved by updating the on-card flashed
firmware from 4.0.530 to 4.0.539. With this firmware, everything seems
to be fine.

Maybe the Linux driver should be adapted to not fail silently if it
doesn't like the on-card firmware but instead log an error message so
that people know they need to update their firmware.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
