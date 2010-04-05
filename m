Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab0DESvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:51:36 -0400
Received: from 152.Red-88-2-254.staticIP.rima-tde.net ([88.2.254.152]:44297
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755879Ab0DESv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:51:26 -0400
Message-ID: <4BBA312B.2030100@sysvalve.es>
Date: Mon, 05 Apr 2010 20:51:23 +0200
From: =?UTF-8?B?IkwuIEFsYmVydG8gR2ltw6luZXoi?= <agimenez@sysvalve.es>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org, linville@tuxdriver.com, j.dumon@option.com,
       steve.glendinning@smsc.com, davem@davemloft.net, gregkh@suse.de,
       dgiagio@gmail.com, dborca@yahoo.com
Subject: Re: [PATCHv3] drivers/net/usb: Add new driver ipheth
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es> <201003312233.26130.oliver@neukum.org> <4BB63619.6070607@sysvalve.es> <201004040924.43949.oliver@neukum.org>
In-Reply-To: <201004040924.43949.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2010 09:24 AM, Oliver Neukum wrote:
> Am Freitag, 2. April 2010 20:23:21 schrieb L. Alberto Giménez:
>> On 03/31/2010 10:33 PM, Oliver Neukum wrote:
>>> Am Mittwoch, 31. März 2010 21:42:07 schrieb L. Alberto Giménez:
>>>> +static struct usb_driver ipheth_driver = {
>>>> +	.name =		"ipheth",
>>>> +	.probe =	ipheth_probe,
>>>> +	.disconnect =	ipheth_disconnect,
>>>> +	.id_table =	ipheth_table,
>>>> +	.supports_autosuspend = 0,
>>> redundant
>> Why?
> 
> 0 is the default.

Heh, I thought that you meant that the whole struct was redundant, and
that puzzled me a little bit. Now everything is clear (my fault for not
realizing the redundant initialization to 0).

Regards,
-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1
