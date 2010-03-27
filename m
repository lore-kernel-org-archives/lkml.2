Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab0C0RCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 13:02:36 -0400
Received: from chrocht.moloch.sk ([62.176.169.44]:39876 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab0C0RCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 13:02:35 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Mar 2010 13:02:35 EDT
Message-ID: <4BAE382D.7090903@250bpm.com>
Date: Sat, 27 Mar 2010 17:54:05 +0100
From: Martin Sustrik <sustrik@250bpm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Christoph Lameter <cl@linux-foundation.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add PGM protocol support to the IP stack
References: <alpine.DEB.2.00.1003181245050.23010@router.home> <87tysccjrn.fsf@basil.nowhere.org> <alpine.DEB.2.00.1003220916170.15360@router.home> <20100322163609.GZ20695@one.firstfloor.org> <alpine.DEB.2.00.1003221146260.17230@router.home> <877hp4i76d.fsf@basil.now <20100327131138.GD20695@one.firstfloor.org>
In-Reply-To: <20100327131138.GD20695@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

> I did a quick read and the manpage/interface seem reasonable to me.

You may also have a look at original PGM implementation by Luigi Rizzo 
(FreeBSD). It's not maintained, but it might give you broader view.

http://info.iet.unipi.it/~luigi/pgm-code/

Martin
