Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab2JKNrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:47:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37903 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab2JKNrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:47:51 -0400
Subject: RE: [PATCH] extcon : callback function to read cable property
From: anish kumar <anish198519851985@gmail.com>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20ADAB092842284E95860F279283C56439BC4A@BGSMSX101.gar.corp.intel.com>
References: <1349864628-21479-1-git-send-email-jenny.tc@intel.com>
	 <1349880328.22926.2.camel@anish-Inspiron-N5050>
	 <20ADAB092842284E95860F279283C56439BC4A@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Oct 2012 22:47:40 +0900
Message-ID: <1349963260.8329.1.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 01:20 +0000, Tc, Jenny wrote:
> > From: anish kumar [mailto:anish198519851985@gmail.com]
> > Sent: Wednesday, October 10, 2012 8:15 PM
> > To: Tc, Jenny
> > Cc: myungjoo.ham@samsung.com; cw00.choi@samsung.com; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH] extcon : callback function to read cable property
> > 
> > I think the reason why we have extcon is in first place is to only notify the
> > clients of cable connection and disconnection and it is up to the client to
> > decide what else to do with the cable such as finding which state it is in and
> > other details.
> > So I feel this should not be handled in the extcon.
> > 
> > However it is up to the maintainer to decide.
> 
> Once the consumer gets the notification, it needs to take some action. 
> One of the action is to read the cable properties. This can be done 
> by proprietary calls which is known both to the consumer and the provider. 
> My intention is to avoid this proprietary calls. Since both the provider 
> and consumer are communicating with the extcon subsystem , I feel having a 
> callback function of this kind would help to avoid the use of proprietary 
> calls. Also I agree that extcon notifier chains are used to notify the cable 
> state (attach/detach). But if a cable has more than two states (like the 
> charger cable) how do we support it without having a callback function like this? 
> Let the maintainer take the final decision.
Well this use case will keep on growing if we start factor in this kind
of changes and that is why I am opposed to adding any other state.
Maintainer?
> 
> 


