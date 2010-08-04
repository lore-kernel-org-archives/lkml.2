Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab0HDH7C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:59:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60589 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0HDH67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=M0Ts6GQgAg7iEKCC2KI0/eSO7WGYLpMAD1H6uYD4IHvrWRYvL16EcFgJUb2AsczaUa
         xyxfVzaHm6FenrfiX7o2AiSxBTwF/YHeNNUrDYPZQfx4BDwQSPlNujlevH4otK1/z8iL
         4BsR5gfQXfKmeu17dBPf8nu/lZ8wiWU/cWHYw=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 0/3] SysRq: do not pass tty argument around
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Airlie <airlied@linux.ie>, David Miller <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>
Date: Wed, 04 Aug 2010 00:58:55 -0700
Message-ID: <20100804075602.30647.91462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following 3 patches get rid of 'tty' argument in SysRq handlers as
nobody is using it. If noone objects I'd like to get it merged through
my tree.

Thanks!

--
Dmitry

