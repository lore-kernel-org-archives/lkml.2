Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab2CUQQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:16:20 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:14369 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759404Ab2CUQQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:16:07 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-131.messagelabs.com!1332346564!16707139!5
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 21 Mar 2012 11:15:57 -0500
Subject: RE: [PATCH RFC] debugfs: rename, export, and use default_open() as
 debugfs_default_open()
Thread-Topic: [PATCH RFC] debugfs: rename, export, and use default_open() as
 debugfs_default_open()
Thread-Index: Ac0HNPCd5H9HTPOzSjSHeejniO+hzAASMm3Q
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020696D488A5@AUSP01VMBX24.collaborationhost.net>
References: <201203201547.05656.hartleys@visionengravers.com>
 <4F698452.1080102@codeaurora.org>
In-Reply-To: <4F698452.1080102@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2LGGQDV012992

On Wednesday, March 21, 2012 12:34 AM, Stephen Boyd wrote:
> On 3/20/2012 3:47 PM, H Hartley Sweeten wrote:
>> Rename default_open() in fs/debugfs/file.c to debugfs_default_open()
>> and export it for use by the many debugfs open() methods that simply
>> do:
>>
>> static int foo_open(struct inode *inode, struct file *file)
>> {
>> 	file->private_data = inode->i_private;
>> 	return 0;
>> }
>>
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>>
>> ---
>>
>
> I sent a patch to introduce simple_open() which is this function ripped
> from debugfs code. I also sent a patch to fixup all the callers
>  (including the non-debugfs ones). Seems like we arrived at the same
> thing. Andrew has picked it up and it is in -mm.

Thanks for the info. I had not seen your patch.

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
