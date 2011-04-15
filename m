Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1DOOEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:04:38 -0400
Received: from swm.pp.se ([212.247.200.143]:54328 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425Ab1DOOEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:04:35 -0400
Date: Fri, 15 Apr 2011 16:04:34 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Mark Lord <kernel@teksavvy.com>
cc: Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
In-Reply-To: <4DA83BAF.2010801@teksavvy.com>
Message-ID: <alpine.DEB.2.00.1104151603460.14027@uplift.swm.pp.se>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com> <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com> <4D9CD275.9000002@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <alpine.DEB.2.00.1104150510181.14027@uplift.swm.pp.se> <4DA7BC4B.9090104@teksavvy.com> <alpine.DEB.2.00.1104150941220.14027@uplift.swm.pp.se> <4DA83BAF.2010801@teksavvy.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Mark Lord wrote:

> Mikael -- any chance you could someday retry this on 2.6.38.2 ?

Well, since the problem went away after I re-seated the SATA cable, I 
don't think I'll even be able to reproduce it with 2.6.32.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
