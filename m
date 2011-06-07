Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1FGSbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:31:04 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7392 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab1FGSbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:31:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6370"; a="96187490"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <014201cc24cf$1b3414d0$519c3e70$@org> <Pine.LNX.4.44L0.1106070941580.1972-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106070941580.1972-100000@iolanthe.rowland.org>
Subject: RE: [PATCH v15 10/10] usb:dummy_hcd: Force FS device connection according to module parameter
Date: Tue, 7 Jun 2011 21:30:46 +0300
Message-ID: <016d01cc2541$0bfa5980$23ef0c80$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: AcwlGTRfPSgnnW8YTb20YkcwBJm7VAAJzkPA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I thought about that as well. Even added it but removed at the last
> minute
> > :) I encountered quite a few places in the code where some error
> message to
> > the user is really needed but is missing
> 
> What other places?  There is very little the user has to do with
> dummy-hcd -- really nothing more than setting the module parameters.

I'm not talking about dummy_hcd. It was a general comment about the gadget
code. I can't give you an example from the top of my head...

> >  so my impression was that it's best
> > to keep the printks to a minimum. Isn't that the general approach?
> IMO, in
> > this particular case informing the user isn't a "must". If you feel
> strongly
> > about it I can add the message.
> 
> IMO the driver should print an error message and fail to load if there
> are contradictory module parameters.
> 

Well, I can add the error message but I think that as far as dummy_hcd is
concerned failing it's loading is a bit harsh, isn't it? I mean, this is a
type of user error that can be fixed so why not fix it and just notify the
user of what was done?


Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




