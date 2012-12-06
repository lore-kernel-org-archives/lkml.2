Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab2LFJPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:15:43 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:60117 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2LFJPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:15:41 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlzKAB1hwFBV5qjOPGdsb2JhbABEgwiCZQGwaIZUBH0XAwEBAQE4NIJfHCMYXSUKGognCMIkFIxeAYMkYQOWAoEdhF6DU4lt
X-IronPort-AV: E=Sophos;i="4.84,229,1355094000"; 
   d="scan'208";a="165046131"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 6 Dec 2012 10:17:44 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Oops in 3.7-rc8 isolate_free_pages_block()
Message-ID: <20121206091744.GA1397@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the third time I encounter this oops in 3.7, but the first
time I managed to get a decent screenshot:

http://bitmath.org/test/oops-3.7-rc8.jpg

It seems to have to do with page migration. I run with transparent
hugepages configured, just for the fun of it.

I am happy to test any suggestions.

Thanks,
Henrik
