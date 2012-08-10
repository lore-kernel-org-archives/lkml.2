Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab2HJIpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 04:45:39 -0400
Received: from plane.gmane.org ([80.91.229.3]:44407 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab2HJIpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 04:45:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>
Subject: Re: 3.5 kernel NULL pointer dereference net_tx_action
Date: Fri, 10 Aug 2012 10:45:19 +0200
Message-ID: <5024CA1F.3060708@web.de>
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com> <4FBBB11D.7020904@web.de> <20120522155345.GC14339@google.com> <4FBBC461.4060008@web.de> <20120522170320.GD14339@google.com> <jpglns$1uj$1@dough.gmane.org> <CAOS58YPMh_hbJ4a49j4p9H68n8U1LzMUuaxmHx57gVTkmfxF6A@mail.gmail.com> <4FBBEDF2.8060803@web.de> <20120523182457.GD18143@google.com> <4FBD40F4.4090201@web.de> <20120523202657.GB3933@htj.dyndns.org> <s5hehq87meg.wl%tiwai@suse.de> <4FBFA637.6000704@web.de> <s5hhav45jpo.wl%tiwai@suse.de> <4FBFD263.60908@web.de> <4FC2262D.2040105@web.de> <s5hbol86g1p.wl%tiwai@suse.de> <50235D10.6080009@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
X-Gmane-NNTP-Posting-Host: p5b379d68.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120805 Icedove/10.0.6
In-Reply-To: <50235D10.6080009@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With stable release 3.5.1 this is cured and WLAN is working flawless again.
Many thanks to the maintainers.
-- 
Jörg-Volker Peetz.

