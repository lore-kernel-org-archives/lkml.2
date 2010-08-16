Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab0HPXgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 19:36:22 -0400
Received: from p01c12o149.mxlogic.net ([208.65.145.72]:42915 "EHLO
	p01c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab0HPXgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 19:36:21 -0400
X-MXL-Hash: 4c69cb7578892aad-5c52ad0de25e428c5e8175c36a9dc0b785be81a6
X-MXL-Hash: 4c69cb736527b90f-05a5c5adeb05d51c60c889daf74531ff4821106b
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "matthew@wil.cx" <matthew@wil.cx>
Date: Mon, 16 Aug 2010 18:36:07 -0500
Subject: RE: [PATCH] fs.h: introduce functions to get/set file->private_data
Thread-Topic: [PATCH] fs.h: introduce functions to get/set file->private_data
Thread-Index: Acs9mUWW9w6679X9Rd+woLutmyN5lgAADuFg
Message-ID: <0D753D10438DA54287A00B0270842697643E50D82E@AUSP01VMBX24.collaborationhost.net>
References: <201008161137.53187.hartleys@visionengravers.com>
 <20100816231753.GA16546@infradead.org>
In-Reply-To: <20100816231753.GA16546@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010073001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.98]
X-AnalysisOut: [v=1.0 c=1 a=Am2CfNgCDXIA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=IRTT+DMug47mVLgYdXzmDg==:17 a=tqKSVTljRAN84FZV7oAA]
X-AnalysisOut: [:9 a=apKAYfiLK1TXbzFg3HVkO6eGw3kA:4 a=CjuIK1q_8ugA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 16, 2010 4:18 PM, Christoph Hellwig wrote:
> On Mon, Aug 16, 2010 at 11:37:52AM -0700, H Hartley Sweeten wrote:
>> The symbol 'private_data' is commonly used and makes grep'ing for
>> specific uses difficult. Introduce the wrapper functions file_get_privdata
>> and file_set_privdata to help with the struct file uses.
>
> This just obsfucates the code, NAK.

Not a problem.

It's just a pain trying to figure out where the file 'private_data' is being
used.

$ git grep private_data | wc -w
37272
$ git grep private_data include | wc -w
1068

The following struct's all have a 'void *private_data' symbol in include/linux:

struct ac97_codec
struct c2port_device
struct file
struct gendisk
struct ata_host
struct ata_queued_cmd
struct ata_device
struct ata_port
struct ata_port_info
struct parport
struct rchan
struct rtc_task
struct plat_serial8250_port
struct uart_port

include/rdma and include/sound also have a number.

Thanks for the reply.

Regards,
Hartley
