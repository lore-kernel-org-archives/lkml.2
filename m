Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab1KQMVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:21:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43180 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab1KQMVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:21:43 -0500
Message-ID: <4EC4FC1F.5020004@mvista.com>
Date: Thu, 17 Nov 2011 16:20:47 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tonylijo <mail@tonylijo.in>
CC: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] usb : gadget : usbstring : fix style problems
References: <1321527544.2367.29.camel@debian1.ic>
In-Reply-To: <1321527544.2367.29.camel@debian1.ic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 17-11-2011 14:59, Tonylijo wrote:

> Minor fixes for problems found by checkpatch.pl in usbstring.c.

    You should have marked the patch as [PATCH v2], not [RESEND] as this is a 
recast patch, not just resend.

WBR, Sergei
