Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab1KPIYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 03:24:50 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:48755 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1KPIYt (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 16 Nov 2011 03:24:49 -0500
MIME-Version: 1.0
In-Reply-To: <20111031191809.GB10164@joana>
References: <2eb6d1b761a3fddea28294959bde7e9c7ef88043.1319086508.git.acho@suse.com>
	<20111031191809.GB10164@joana>
Date: Wed, 16 Nov 2011 16:24:40 +0800
Message-ID: <CAKzePaqwKbg8oZ6ULcdXdnYAkLU+k6o3bQWVaLUfCEDrH2994g@mail.gmail.com>
Subject: Re: [PATCH 1/2] add device entry for Broadcom Valentine combo card
From: Al Cho <acho@suse.com>
To: "Cho, Yu-Chen" <acho@suse.com>, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        acho@novell.com, jlee@novell.com, oneukum@suse.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

Sorry for late to reply,

On Tue, Nov 1, 2011 at 3:18 AM, Gustavo Padovan <padovan@profusion.mobi> wrote:
> Hi Yu-Chen,
>
> * Cho, Yu-Chen <acho@suse.com> [2011-10-20 12:58:29 +0800]:
>
>> This device declares itself to be vendor specific
>> It therefore needs to be added to the device table
>> to make btusb bind.
>
> It would be good to have the output of usb-devices for this specific device in
> the commit message.

Would you please kindly explain what is "the output of usb-device" to me?
The patch is for Broadcom Valentine 802.11bgn 1x1 wireless and
bluetooth combo card.

Thanks,
           AL
