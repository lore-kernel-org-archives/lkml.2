Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab2DNJAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:00:42 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:39832 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2DNJAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:00:40 -0400
X-Greylist: delayed 3172 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2012 05:00:40 EDT
Message-ID: <4F89304F.1070406@freemail.hu>
Date: Sat, 14 Apr 2012 10:07:43 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>, discuss <discuss@lesswatts.org>,
        Powertop Mailing List <power@bughost.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: where can I find powertop sorces?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.16.156
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having trouble to fetch powertop sources. I found the article
titled "Announcing the beta release of PowerTOP 2.0" from January 5 2011
at http://lwn.net/Articles/421733/ but it seems that the links are not
working anymore:

$ git clone git://git.kernel.org/pub/scm/status/powertop/powertop.git
Cloning into powertop...
warning: You appear to have cloned an empty repository.
$ wget http://www.kernel.org/pub/linux/status/powertop/powertop-1.97.tar.bz2
--2012-04-14 10:04:55--  http://www.kernel.org/pub/linux/status/powertop/powertop-1.97.tar.bz2
Resolving www.kernel.org... 149.20.20.133, 149.20.4.69
Connecting to www.kernel.org|149.20.20.133|:80... connected.
HTTP request sent, awaiting response... 403 Forbidden
2012-04-14 10:04:56 ERROR 403: Forbidden.

Regards,

	Márton Németh
