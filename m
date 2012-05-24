Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab2EXPDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:03:54 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:36569 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2EXPDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:03:53 -0400
Message-ID: <4FBE4DD5.50906@xs4all.nl>
Date: Thu, 24 May 2012 17:03:49 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: pwc driver bugs
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I discovered some issues in the pwc driver for certain USB webcams.
I opened some bugs[1].
I do think both issues might be related and the crash issue is quite
serious.

Please have a look, I can assist by testing any patches with fixes. (for
~3.3.7)

Kind regards,
Udo


[1]: https://bugzilla.kernel.org/show_bug.cgi?id=43291  		
     https://bugzilla.kernel.org/show_bug.cgi?id=43290
