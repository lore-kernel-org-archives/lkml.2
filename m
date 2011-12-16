Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657Ab1LPQX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:23:29 -0500
Received: from gretna.indigovision.com ([62.7.85.227]:9567 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab1LPQXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:23:23 -0500
From: Bruce Stenning <b.stenning@indigovision.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Date: Fri, 16 Dec 2011 16:23:17 +0000
Subject: RE: BUG_ON triggered in worker_enter_idle, after power failure
 caused potential RAID corruption (kernel 2.6.39.4)
Thread-Topic: BUG_ON triggered in worker_enter_idle, after power failure
 caused potential RAID corruption (kernel 2.6.39.4)
Thread-Index: AcylRuW19Yk6+6oHT4iCMvhUD0LgmQAyeWdgBX976KA=
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32D9B2997C8@gretna.indigovision.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Has anyone seen similar problems with RAID issues triggering this or
> similar BUG_ON statements in workqueue?  I have done some extensive
> web searching and delving through the latest git repositories, but
> have not found anything that stands out so far.

These problems have been tracked down to the following issue:

http://article.gmane.org/gmane.linux.raid/33553

Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
