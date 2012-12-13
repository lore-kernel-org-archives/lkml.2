Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2LMNEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:04:06 -0500
Received: from kwak.cryptyx.com ([176.9.47.209]:33521 "EHLO kwak.cryptyx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab2LMNEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:04:04 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2012 08:04:04 EST
Message-ID: <50C9D085.3020305@junod.info>
Date: Thu, 13 Dec 2012 13:56:37 +0100
From: Pascal Junod <pascal@junod.info>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: pascal@junod.info
Subject: [btrfs] is vulnerable to a hash-DoS attack
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folk,

The btrfs file system, part of the linux kernel, is vulnerable to a
trivial hash-DoS attack. More details can be found here:

http://crypto.junod.info/2012/12/13/hash-dos-and-btrfs/

Enjoy!

Pascal Junod
--
http://crypto.junod.info
@cryptopathe
