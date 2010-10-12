Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab0JLNZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:25:18 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50095 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932287Ab0JLNZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:25:16 -0400
X-Sasl-enc: NKQwCDBHHACwR6VcvgeLPr8vrRbtWSq83v1XgioJFj1B 1286889915
Date: Tue, 12 Oct 2010 10:25:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: dm-crypt: plain64 IV support for -stable?
Message-ID: <20101012132511.GA24455@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would it be possible to add commit 61afef614b013ee1b767cdd10325acae1db1f4d2
"dm crypt: add plain64 iv" to -stable?

Without it, users of LTS kernels like 2.6.32 are missing important
functionality (as in: might not be able to mount some LUKS volumes
created on newer kernels).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
