Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab1FLPWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 11:22:24 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:44708 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1FLPWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 11:22:22 -0400
X-SENDER-IP: [85.230.169.19]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmthAPbY9E1V5qkTPGdsb2JhbABSiRGdPAsBAQEBNzKIcr9QDoYWBJYRiwI
X-IronPort-AV: E=Sophos;i="4.65,355,1304287200"; 
   d="scan'208";a="20413389"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 12 Jun 2011 17:29:15 +0200
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid-multitouch: fix broken eGalax
Message-ID: <20110612152915.GA18794@polaris.bitmath.org>
References: <1307859728-3446-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307859728-3446-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> With this patch, the detection is made only when the field ContactID
> has been detected inside the collection.

The patch introduces an order dependence by relying on ContactID
occuring early on, which seems unnecessary. How about checking for the
presence of ContactID instead, and simply modify the logic which uses
last_field_index and last_slot_field?

Thanks,
Henrik
