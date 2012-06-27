Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2F0QqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 12:46:10 -0400
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:48961 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627Ab2F0QqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 12:46:08 -0400
X-Greylist: delayed 890 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2012 12:46:08 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=BVQufhN7Gp8HtscWNPL11v036BAwvzdFbRfyQ+J63rhzecC9T8kQq1expMW/bkiZ;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4FEB3553.8050609@earthlink.net>
Date: Wed, 27 Jun 2012 12:31:15 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 00/36] staging: comedi: cb_pcidas: cleanup the driver
References: <201206261745.00636.hartleys@visionengravers.com>
In-Reply-To: <201206261745.00636.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79fd9e4f2f96e703866e47bcb6209df1c7350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 69.22.83.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 08:45 PM, H Hartley Sweeten wrote:
> Cleanup the cb_pcidas driver.
>
> H Hartley Sweeten (36):
>    staging: comedi: cb_pcidas: remove forward declarations 1
>    staging: comedi: cb_pcidas: remove forward declarations 2
>    staging: comedi: cb_pcidas: remove forward declarations 3
>    staging: comedi: cb_pcidas: remove forward declarations 4
>    staging: comedi: cb_pcidas: remove forward declarations 5
>    staging: comedi: cb_pcidas: remove forward declarations 6
>    staging: comedi: cb_pcidas: remove forward declarations 7
>    staging: comedi: cb_pcidas: remove forward declarations 8
>    staging: comedi: cb_pcidas: remove forward declarations 9
>    staging: comedi: cb_pcidas: remove thisboard and devpriv macros
>    staging: comedi: cb_pcidas: factor out the find pci device code
>    staging: comedi: cb_pcidas: remove some obvious comments in the
>      attach
>    staging: comedi: cb_pcidas: remove the PCI BAR index defines
>    staging: comedi: cb_pcidas: remove CB_PCIDAS_DEBUG define
>    staging: comedi: cb_pcidas: remove unused io region size defines
>    staging: comedi: cb_pcidas: simplify the boardinfo
>    staging: comedi: cb_pcidas: cleanup the boardinfo 1
>    staging: comedi: cb_pcidas: cleanup the boardinfo 2
>    staging: comedi: cb_pcidas: cleanup the boardinfo 3
>    staging: comedi: cb_pcidas: cleanup the boardinfo 4
>    staging: comedi: cb_pcidas: cleanup ai_config_insn()
>    staging: comedi: cb_pcidas: move the "find pci" dev_printk messages
>    staging: comedi: cb_pcidas: use the driver_name for the resource name
>    staging: comedi: cb_pcidas: check for failure of subdev_8255_init
>    staging: comedi: cb_pcidas: fix a space before tab issue
>    staging: comedi: cb_pcidas: fix some>  80 char lines
>    staging: comedi: cb_pcidas: fix comments in *_cmdtest functions
>    staging: comedi: cb_pcidas: remove 'volatile' on private data
>      variables
>    staging: comedi: cb_pcidas: fix comments in private data struct
>    staging: comedi: cb_pcidas: change dac bit enums into defines
>    staging: comedi: cb_pcidas: add whitespace to all the #define's
>    staging: comedi: cb_pcidas: fix remaining checkpatch.pl issues
>    staging: comedi: cb_pcidas: cleanup cb_pcidas_ao_fifo_winsn()
>    staging: comedi: cb_pcidas: cleanup cb_pcidas_ao_nofifo_winsn()
>    staging: comedi: cb_pcidas: cleanup cb_pcidas_ai_rinsn()
>    staging: comedi: cb_pcidas: cleanup dac08_write()
>
>   drivers/staging/comedi/drivers/cb_pcidas.c | 1695 +++++++++++++---------------
>   1 file changed, 770 insertions(+), 925 deletions(-)
>
>    
I there some reason you can't post these as response to this message, 
like GKH does, so if readers aren't
interested they can mark the thread read without stepping thru each patch.

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



