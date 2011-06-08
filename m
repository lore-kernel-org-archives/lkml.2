Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab1FHVjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:39:13 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49518 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab1FHVjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:39:09 -0400
X-Sasl-enc: if8/SGqIQNyseVgYu4rELHBdGS+CUhjs+p0EaQShXWZ0 1307569149
Date: Wed, 8 Jun 2011 18:39:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Lars =?iso-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load
Message-ID: <20110608213905.GA26654@khazad-dum.debian.net>
References: <20110606095127.21d23a70.taeuber@bbaw.de>
 <20110608123003.3569604f.taeuber@bbaw.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110608123003.3569604f.taeuber@bbaw.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jun 2011, Lars Täuber wrote:
> Am I the only one using SW-RAID6 and having this problem?

Well, ask Arecca if these disks have problems with their RAID
controllers, and whether they can help you get hold of firmware updates
for the WD disks.

The WD RE4-GP 2TB might not be the only WD RE4 disk with quirky
firmware.

http://blog.fastmail.fm/2009/11/06/western-digital-re4-gp-2tb-drive-problems-and-solutions/
http://kb.lsi.com/KnowledgebaseArticle15592.aspx?Keywords=Re4+firmware

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
