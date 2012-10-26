Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab2JZGUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:20:23 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:57470 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab2JZGUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:20:19 -0400
Message-ID: <508A2AC8.9000304@synopsys.com>
Date: Fri, 26 Oct 2012 11:46:40 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <alan@linux.intel.com>, <arc-linux-dev@synopsys.com>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] serial/arc-uart: Add New Driver
References: <1351146608-21044-1-git-send-email-vgupta@synopsys.com> <20121025183643.GA22504@kroah.com>
In-Reply-To: <20121025183643.GA22504@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.56]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2012 12:06 AM, Greg KH wrote:
> On Thu, Oct 25, 2012 at 12:00:07PM +0530, Vineet.Gupta1@synopsys.com wrote:
>> From: Vineet Gupta <vgupta@synopsys.com>
>>
>> Hi Greg,
>>
>> Rebased off of tty-next and verfied that it builds fine.
> Did you run it?

Absolutely ! What I meant was, this specific version (rebased off of
tty-next) can't be run for ARC platform yet (for which this driver is
originally meant). The preceding version based off of 3.6 (including all
of Alan's review comments) already runs for our 3.6 kernel.

>
>> Please consider applying.
> I can't, see my review comments.

Updated revision to follow

Thx,
-Vineet
>
> thanks,
>
> greg k-h

