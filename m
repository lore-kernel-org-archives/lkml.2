Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab0ETMA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 08:00:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:34267 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab0ETMAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 08:00:55 -0400
Date: Thu, 20 May 2010 14:00:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kevin McKinney <klmckinney1@gmail.com>,
       Daniel Chen <seven.steps@gmail.com>, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org
Subject: Re: Logitech Headset
In-Reply-To: <AANLkTilYTbyFLP4J91zOwckbsegA7-udGT8xGin4DCBO@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1005201400120.14809@twin.jikos.cz>
References: <h2h6d38d2f91004271023hc2d2b69ekbfd40fe97d5b2566@mail.gmail.com>  <1272473196.1827.91.camel@lenovo> <y2u604760771004281000y3d80fe59v15871802d3d0d9f2@mail.gmail.com>  <r2r6d38d2f91004281555n6322c65dhe19b01a6dfe42771@mail.gmail.com> 
 <AANLkTil1Rr9IGxan8diaQNwNmFnljQs3w0j3oyQoGLgA@mail.gmail.com>  <AANLkTimSlLNf2b1YVBkUrFLM3PmRGmgVyBNMjNNccd8q@mail.gmail.com>  <AANLkTin3AJJRAV3HD0aKPbkG1oxrrl6uAO8aGQWgguw0@mail.gmail.com>  <AANLkTilJIhcCkRDw4UoQFIMxHbtvGodxKr7MtP1qFGxY@mail.gmail.com> 
 <AANLkTinybFoRb7FJE4yj8zy3Bgi_2dw6SFMkXWkt4c3x@mail.gmail.com> <AANLkTilYTbyFLP4J91zOwckbsegA7-udGT8xGin4DCBO@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010, Luis R. Rodriguez wrote:

> On Wed, May 19, 2010 at 9:10 AM, Kevin McKinney <klmckinney1@gmail.com> wrote:
> > Luis,
> > Yes, I tried it about two months ago with not luck. I also performed a grep
> > on the source code and did not find the device ID specified.

That doesn't mean anything. USB drivers are free to bind to devices based 
on USB class, not on VID/PID (and a lot of class drivers actually do 
that).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

