Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab0HCPGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:06:04 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37384 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351Ab0HCPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:06:00 -0400
X-Sasl-enc: I7wvNyJRXjU1YLC8/2Ag7IBho+QZztOWCGhiyGvH2sco 1280847957
Date: Tue, 3 Aug 2010 12:05:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35
Message-ID: <20100803150551.GA15530@khazad-dum.debian.net>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
 <20100802023322.GA19164@dastard>
 <87tyncds89.fsf@basil.nowhere.org>
 <20100803092823.GA5324@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803092823.GA5324@amd>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010, Nick Piggin wrote:
> I was under the impression that ACLs on directories are not that common,
> so maybe this is as far as we need to go for now anyway.

They are quite common on fileserver data areas, at least on the places where
I worked at.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
