Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500Ab2CMT3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:29:13 -0400
Received: from fly.hiwaay.net ([216.180.54.1]:37763 "EHLO fly.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab2CMT3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:29:11 -0400
X-Greylist: delayed 1191 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2012 15:29:11 EDT
Date: Tue, 13 Mar 2012 14:09:16 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Cc: bugme-admin@linux-foundation.org
Subject: Re: Is bugzilla's SSL certificate invalid?
Message-ID: <20120313190916.GA32096@hiwaay.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <197377679.301107.1331660231517.JavaMail.mail@webmail07>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Artem S. Tashkinov <t.artem@lycos.com> said:
>Some of my web browsers (google chrome and opera) say that the
>bugzilla's SSL certificate is invalid.
>
>"The site's security certificate is not trusted!

Yes, somebody didn't follow Thawte's instructions when installing the
certificate on bugzilla.kernel.org.  They should install the correct
intermediate cert(s) from:

https://search.thawte.com/support/ssl-digital-certificates/index?page=content&id=AR1384

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
