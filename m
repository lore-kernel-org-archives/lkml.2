Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1CHMpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:45:46 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:4996 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1CHMpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:45:45 -0500
X-IronPort-AV: E=Sophos;i="4.62,284,1297036800"; 
   d="scan'208";a="4671145"
Date: Tue, 8 Mar 2011 12:45:25 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: topperxin <topperxin@126.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re:Re:Re:[Xen-devel] [PATCH v2 0/6] Xen PV on HVM fixes and
 improvements
In-Reply-To: <37633ce9.14869.12e95634727.Coremail.topperxin@126.com>
Message-ID: <alpine.DEB.2.00.1103081215270.2968@kaball-desktop>
References: <alpine.DEB.2.00.1103081115250.2968@kaball-desktop> <alpine.DEB.2.00.1103031502090.2968@kaball-desktop> <alpine.DEB.2.00.1102251651570.19277@kaball-desktop> <50e6b629.254d.12e798c9072.Coremail.topperxin@126.com> <7ef859a1.d96b.12e933f972a.Coremail.topperxin@126.com>
 <37633ce9.14869.12e95634727.Coremail.topperxin@126.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-1735475764-1299586586=:2968"
Content-ID: <alpine.DEB.2.00.1103081223310.2968@kaball-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-1735475764-1299586586=:2968
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1103081223311.2968@kaball-desktop>

On Tue, 8 Mar 2011, topperxin wrote:
> >you must be working on the wrong tree :)
> 
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.38-rc6-pvhvm
> isn't it? I get it from this address, you given in the mail.
> cloud you please give me a right address?
> thanks a lot.
 
You probably cloned my master branch: 2.6.38-rc6-pvhvm is the name of a
branch, if you executed:

git clone git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.38-rc6-pvhvm

you just cloned the "master" branch in a directory named "2.6.38-rc6-pvhvm".

try:

git remote update
git branch -r

you should get a list of remote branches available, among which
"2.6.38-rc6-pvhvm".

At this point you can checkout the branch 2.6.38-rc6-pvhvm with this
command:

git checkout -b your_branch_name "origin/2.6.38-rc6-pvhvm"
--8323329-1735475764-1299586586=:2968--
