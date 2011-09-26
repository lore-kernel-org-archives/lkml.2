Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab1IZQyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 12:54:20 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:58861 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab1IZQyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 12:54:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-127.messagelabs.com!1317056056!7793020!6
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Steven Whitehouse <swhiteho@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>
Date: Mon, 26 Sep 2011 11:54:08 -0500
Subject: RE: [PATCH] gfs2/inode.c: local functions should be static
Thread-Topic: [PATCH] gfs2/inode.c: local functions should be static
Thread-Index: Acx8JfHu/BwbLAYrTpOlz4fibC/EfwARjW4g
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39DBB86BD@AUSP01VMBX24.collaborationhost.net>
References: <201109231551.32939.hartleys@visionengravers.com>
 <1317025658.2744.0.camel@menhir>
In-Reply-To: <1317025658.2744.0.camel@menhir>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8QGsY8h019139

On Monday, September 26, 2011 1:28 AM, Steven Whitehouse wrote:
> Hi,
>
> On Fri, 2011-09-23 at 15:51 -0700, H Hartley Sweeten wrote:
>> Quiets the sparse noise:
>> 
>> warning: symbol 'gfs2_initxattrs' was not declared. Should it be static?
>> 
> Where did you find this function? It is not in the upstream gfs2 code...

linux-next next-20110831

This was the last update I pulled before git.kernel.org went down.

It looks like it was added by:

commit 9d8f13ba3f4833219e50767b022b82cd0da930eb
Author: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date:   Mon Jun 6 15:29:25 2011 -0400

    security: new security_inode_init_security API adds function callback

If this has been removed since then please ignore.

Thanks,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
