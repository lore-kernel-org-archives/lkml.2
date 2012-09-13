Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415Ab2IMRwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:52:33 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:35272 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab2IMRwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:52:31 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlupAOgcUlBV5h1yPGdsb2JhbABFhR4jhQCwOAEBAnoZAQEBATc0giABAQQBJxMcIwULCANGFCUKGogaCrtwFIsuAlFdg3VgA5VfhXCNGg
X-IronPort-AV: E=Sophos;i="4.80,418,1344204000"; 
   d="scan'208";a="408968784"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 13 Sep 2012 19:59:31 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/20] Input: Send events one packet at a time
Message-ID: <20120913175931.GA3178@polaris.bitmath.org>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
 <1346528835-363-6-git-send-email-rydberg@euromail.se>
 <20120913065613.GG17105@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913065613.GG17105@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Filter handlers do not typically have ->event() methods, that's the
> reason for reported panic.

If we decide to rewind the tree, I will amend the fix here.

Thanks,
Henrik
