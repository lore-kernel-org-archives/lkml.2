Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab1DEAyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 20:54:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48065 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab1DEAyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 20:54:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=DU+ETPP6JheT9WCEwK24nZBwXEIepLEmjxnHzYbpgsotlXp/N0awYWihidMPjmifsY
         oFHvWbeTu+XQBNK8N1tHKeJQtQo6lQn/RFhnLvWLly3On5o2BJD4riR3ivWlbt67xLXL
         wwb6CcMd91l1/EcA9z8WfSU8jOJxyFuVhHZJE=
MIME-Version: 1.0
From: Timur Tabi <timur@freescale.com>
Date: Mon, 4 Apr 2011 19:53:50 -0500
X-Google-Sender-Auth: qn4DEUARKV3-KZMvxhkZ-Cz_qgc
Message-ID: <BANLkTikQk0OAS+41g=pk9BaqAWaVhQB9rg@mail.gmail.com>
Subject: Ok to call disable_irq before request_irq?
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it okay to call disable_irq() before calling request_irq()?  My
device creates lots of spurious interrupts, and so I want the
interrupt enable only when I expect a real interrupt to occur.  It
seems to work, but I just want to make sure it's a proper technique.

-- 
Timur Tabi
Linux kernel developer at Freescale
