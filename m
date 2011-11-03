Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281Ab1KCS2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 14:28:35 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:32873 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756446Ab1KCS2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 14:28:34 -0400
X-Sasl-enc: 9+kedVHz8gLGWxSOAF4e3unN+KTf1dbOT3UfBTgYVKdo 1320344913
Date: Thu, 3 Nov 2011 16:28:30 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Timo Jyrinki <timo.jyrinki@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Simultaneous cat and external keyboard input causing kernel
 panic
Message-ID: <20111103182830.GB3844@khazad-dum.debian.net>
References: <CAJtFfxmovJHspHHKbvBVc4pw+u5mjGmUejCXEzdV+GqE=jVSOQ@mail.gmail.com>
 <4EB2AD70.7060607@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB2AD70.7060607@ladisch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Nov 2011, Clemens Ladisch wrote:
> Timo Jyrinki wrote:
> > Then suddenly the cat shifted his position and there was a kernel panic
> 
> Your cat wanted to find out what the magic in "magic SysRq key" means
> and pressed Alt+SysRq+C.  The problem is that he did not consult
> Documentation/sysrq.txt first; the "C" does _not_ stand for "catnip".

Yes, it was a catastrophe.

Truth is, cats are great panic generators and as fuzzy beings themselves,
they're also great fuzzers.  Only, normally they restrict themselves to
fuzzing clothes, computer fans, their owner's food, spreadsheets, the nose
of anyone alergic to catty fuzzy feelings in a 100m radius, word
processors, and IRS forms.

However, it is the first time I've seen documented proof that a cat
sucessfully fuzzed an input device into a panic.  Must be a lolcat's revenge
to the lack of mouses since touchpads took over.  And Linux has no
cat-proofing for the keyboard and touchpads[1], which will leave us
wide-open to surprise fuzzer attacks from the lolcats!  Maybe we should
issue a CVE about it?

;-)

[1] Windows _has_ third-party cat-proofing for keyboards, by detecting
clustered pressing of nearby keys.  I don't think it can yet figure out a
catpaw press on the touchpad, however.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
