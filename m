Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454Ab2C3CZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 22:25:39 -0400
Received: from asix.com.tw ([113.196.140.82]:58928 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759929Ab2C3CZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 22:25:34 -0400
From: "Donald" <donald@asix.com.tw>
To: "'Greg KH'" <gregkh@linuxfoundation.org>
Cc: "'open list:USB SUBSYSTEM'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <009c01cd00ee$924eb2e0$b6ec18a0$@com.tw> <20120313160951.GA18810@kroah.com> <005a01cd0db0$8ec89e50$ac59daf0$@com.tw> <20120329151343.GA32474@kroah.com>
In-Reply-To: <20120329151343.GA32474@kroah.com>
Subject: RE: Patch "USB: serial: mos7840: Supported MCS7810 device"
Date: Fri, 30 Mar 2012 10:21:37 +0800
Message-ID: <002f01cd0e1b$d8f2d070$8ad87150$@com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac0NvqNnI32HMqVjSZa0GVUAiv0SUgAXIgPg
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thank you for your quick reply. I will refine the patch according to Alan's
comments and redo this patch against 3.4-rc1 and re-submit it ASAP.

Regards,
Donald

-----Original Message-----
From: 'Greg KH' [mailto:gregkh@linuxfoundation.org] 
Sent: Thursday, March 29, 2012 11:14 PM
To: Donald
Cc: 'open list:USB SUBSYSTEM'; 'open list'
Subject: Re: Patch "USB: serial: mos7840: Supported MCS7810 device"

On Thu, Mar 29, 2012 at 09:33:36PM +0800, Donald wrote:
> Hi Greg,
> 
> I am submitting this patch that supports MCS7810 device for the 
> mos7840 driver. If you see any problem regarding this patch, please 
> let me know at any time. Thank you for your help.
> 
> Regards,
> Donald
> 
> Patch Description:
> This patch added the support of MCS7810 device for the mos7840 driver. 
> The MCS7810 device supports single USB2.0-to-Serial port with a LED 
> indicator for reflecting transmission or reception activity. Please be 
> noted that part of codes in his patch are relating to the codes in 
> last submitted patch that fixed MCS7820 device attach problem.

Along with Alan's comments, I need this to be able to be applied, and if you
include portions of the patch that I have already accepted, I can't apply
it, right?

Can you redo this patch against 3.4-rc1 when it comes out in a few days?

thanks,

greg k-h


