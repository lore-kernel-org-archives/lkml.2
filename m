Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936002Ab0GPIjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 04:39:23 -0400
Received: from smtp.nokia.com ([192.100.122.233]:32226 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935955Ab0GPIjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 04:39:21 -0400
Message-ID: <4C401AA3.8010806@nokia.com>
Date: Fri, 16 Jul 2010 11:38:59 +0300
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "me@felipebalbi.com" <me@felipebalbi.com>
CC: ext Andy Shevchenko <andy.shevchenko@gmail.com>,
        Micha?? Nazarewicz <m.nazarewicz@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shevchenko Andriy (EXT-Teleca/Helsinki)" 
	<ext-andriy.shevchenko@nokia.com>,
        "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
        "Hunter Adrian (Nokia-MS/Helsinki)" <adrian.hunter@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: storage: optional SCSI WRITE FUA bit
References: <Pine.LNX.4.44L0.1007131003560.1568-100000@iolanthe.rowland.org> <1279098331-7872-1-git-send-email-ext-andriy.shevchenko@nokia.com> <op.vft2p6do7p4s8u@pikus> <AANLkTil1eG5yzBxvryf-TZINYjeGph-rNz8eELQtm5tj@mail.gmail.com> <4C3DC1D5.4060406@nokia.com> <20100716075439.GA25553@gandalf>
In-Reply-To: <20100716075439.GA25553@gandalf>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2010 08:38:40.0304 (UTC) FILETIME=[4A8A8B00:01CB24C2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 10:54 AM, ext Felipe Balbi wrote:
> Hi,
>
> On Wed, Jul 14, 2010 at 04:55:33PM +0300, Roger Quadros wrote:
>> file_storage driver does not deal with partitions. only mediums.
>
> it deals with backing files, no matter if it's a medium, partition or a
> file on a file system (using a loop-device).
>
True, you are talking from the device side of the g_files_storage where it 
accesses backing files, I was talking from the USB side, where g_file_storage 
exposes LUNs or Mediums and not partitions.

br,
-roger
