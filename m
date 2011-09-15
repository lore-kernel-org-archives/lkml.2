Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934797Ab1IOUY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:24:29 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:59494 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934640Ab1IOUY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:24:27 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <error27@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 06/20] Staging: hv: util: Properly handle util services
 in the util driver
Thread-Topic: [PATCH 06/20] Staging: hv: util: Properly handle util services
 in the util driver
Thread-Index: AQHMcjvtYv4obMHbH0CnnF+Bjxcf2ZVPV3WA//+OguA=
Date: Thu, 15 Sep 2011 20:24:26 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081E7311@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-6-git-send-email-kys@microsoft.com>
 <20110915200853.GJ3789@shale.localdomain>
In-Reply-To: <20110915200853.GJ3789@shale.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:error27@gmail.com]
> Sent: Thursday, September 15, 2011 4:09 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 06/20] Staging: hv: util: Properly handle util services in the
> util driver
> 
> On Tue, Sep 13, 2011 at 10:59:42AM -0700, K. Y. Srinivasan wrote:
> > @@ -403,31 +384,13 @@ static void vmbus_process_offer(struct work_struct
> *work)
> >  		spin_unlock_irqrestore(&vmbus_connection.channel_lock,
> flags);
> >
> >  		free_channel(newchannel);
> > -	} else {
> > +	} else
> >  		/*
> >  		 * This state is used to indicate a successful open
> >  		 * so that when we do close the channel normally, we
> >  		 * can cleanup properly
> >  		 */
> >  		newchannel->state = CHANNEL_OPEN_STATE;
> 
> It's not worth resending, but this should have kept the curly braces
> for two style reasons.
> 1) If one side of the if else pair has braces the other side gets
> braces too.
> 2) If it's more than one line, it gets braces even if it's not needed
> for semantic reasons.
> 
> Sorry to email you these pedantic things, but if I don't then my OCD
> acts up and I feel all itchy for hours.  Also you have a similar
> thing below as well.

Thanks Dan. I will wait for Greg's action here. Given that Kernel.org is still
down, we are all kind of flying in the dark here.

Regards,

K. Y

