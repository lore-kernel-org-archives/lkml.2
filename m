Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1GDFjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 01:39:24 -0400
Received: from relay03.digicable.hu ([92.249.128.185]:58462 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab1GDFjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 01:39:21 -0400
Message-ID: <4E1151BD.5010907@freemail.hu>
Date: Mon, 04 Jul 2011 07:38:05 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David Chang <DChang@novell.com>, Matt Mooney <mfm@muteddisk.com>,
        Matt Chen <machen@novell.com>
CC: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
        Max Vozeler <max@vozeler.com>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, usbip-devel@lists.sourceforge.net,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] USBIP protocol documentation
References: <4DDBF8BD.3000603@freemail.hu>	<20110524183448.GA18511@kroah.com>	<4DDC142E.6070003@freemail.hu>	<20110525031222.GB14290@haskell.muteddisk.com>	<4DDC93D5.9070607@freemail.hu>	<4DDDFDA7.6030900@freemail.hu>	<4E097A32.1000504@freemail.hu>	<BANLkTimG_kWr_YPVMasUr+7+KRFPnnbjNw@mail.gmail.com> <CAL-cBk1L8dgAtP2hMwkL2B-cU76mKaaWib=QVbVKei2DaoB3Dw@mail.gmail.com>
In-Reply-To: <CAL-cBk1L8dgAtP2hMwkL2B-cU76mKaaWib=QVbVKei2DaoB3Dw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Original: 94.21.49.34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, Matt Chen and Matt Mooney,

it looks like we four are actively dealing with the USBIP protocol documentation.

David, are you working at the same place like Matt Chen? Then you can easily
see what you two has been done and not working parallel on the same thing.

I'm currently not actively modifying the USBIP protocol description.

Matt Mooney wanted to restructure the USBIP protocol documentation. Matt, do
you have anything already done? If yes, maybe it would be good if you could
send it so David can do the changes on your version. If you haven't worked on
it then please tell and David can add the necessary modifications he suggested.

Regards,

	Márton Németh

David Chang wrote:
> Hi Németh,
> 
> 2011/6/29 David Chang <dchang@novell.com>:
>> Hi,
>>
>> Thanks for your great effort.
>> Just a little comment on UNLINK pdu size.
[...]
> Would you add this field into your path or should I send another patch
> to add it?

