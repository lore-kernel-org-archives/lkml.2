Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab0CUNEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 09:04:31 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36385 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab0CUNEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 09:04:30 -0400
X-Sasl-enc: M8DzHsC0Q/Lsiz+Yr4D7os3jlC1cLe1LJTxkvtUez6DB 1269176668
Date: Sun, 21 Mar 2010 10:04:26 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: jin zhencheng <zhenchengjin@gmail.com>
Cc: Joachim Otahal <Jou@gmx.net>,
       Kristleifur =?iso-8859-1?Q?Da=F0ason?= <kristleifur@gmail.com>,
       neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG:write data to degrade raid5
Message-ID: <20100321130426.GB15746@khazad-dum.debian.net>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
 <4BA3C07A.8030204@gmx.net>
 <73e903671003191123h1b7e1196v336265842f1b29e5@mail.gmail.com>
 <4BA3C461.5060209@gmx.net>
 <de04351e1003210329w21f4731as3597245562a390d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de04351e1003210329w21f4731as3597245562a390d@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010, jin zhencheng wrote:
> ths for your test on "Debian 2.6.26-21lenny4".
> if you want to see the oop ,you should always write to the raid5 ,and
> pull 2 disks out.maybe you can see the error
> 
> i think no matter what i do ,even if i pull out all the disk , kernel
> should not oop.

You don't have swap (file or partition, doesn't matter) on that RAID, do
you?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
