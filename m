Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330Ab0HEU6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:58:11 -0400
Received: from n2c.bullet.mail.ac4.yahoo.com ([76.13.13.79]:28535 "HELO
	n2c.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932426Ab0HEU6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:58:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 577111.13170.bm@omp131.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=2jk4frtssxDinuWqh+YcEp3W4CNhs2lM5k6nH36f7WIyh1H1twdmDZZtw5nB4eIS/3xjAp3WRJ1C43vbIHPxtAiSu4jnnSdg/NRIEQagRq64lieYBNvqdLeb5wDZJzIga69lKPuPuE10guLvJ8JMJz7aVDVuBr8lV/uQ4n/1OOg=;
Message-ID: <312769.16763.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: nGS0hEoVM1lLB0kbKqz9ZoPXqibmn7tcD3df_m3UbiKL8yZ
 29sB7SrjUSPuxVqGvmR5G5nh923BCXAeuubprzitp1AXbs6OycE2Ym.deiSw
 bTnIrqvG5l3KBCKmry24DZhKC0nG7wyyCLBbTPDjHfYnvgNdqGs79.CbdK5Y
 4X8Z.Jb5cFUYePlA2D6sCSwaTjo18Fq_uG1QwoblS_X0jYwpomRQ4_WkXeK9
 xUqEdAt88VUR33Ju9zLJ_DC8y2RFkUIaMuWZGmDNf0KbZ_eFRBSV9ljAJbaJ
 PUZfkfbFJQsbDBWK61YevrWhspRqkcCq6eER27QA-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 5 Aug 2010 13:58:06 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCHv6 4/7] USB: gadget: composite: Better string override handling
To: Greg KH <greg@kroah.com>, USB <linux-usb@vger.kernel.org>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>,
        Vladimir Pankratov <scriptkid@mail.ru>,
        Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <f663aae67270ec7bf8732b1ba48b6030ded70355.1281002833.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I guess.  This version does not have the
hard-wired serial number some previous versions had.

However, I can't put the time in for a real review
and test session, so I'll have to hope this doesn't
have any subtle bugs such review would uncover.

- Dave


