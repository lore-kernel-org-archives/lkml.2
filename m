Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab1EKQJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:09:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50748 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab1EKQI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=uAXA2+ukMu8nQQuCoejfi6Y47yfFeHCZvFPz1SXFatPBZOr6pIq92la1tROZGkNXmC
         jTSjh/Cdd+CDgb7NxUNDVbaCb5H+1Wngtp7OTvkuwTHJuC8Bt+ly/+/AA7uMmTb/Wu0T
         llQx24cmsI1b+LBKHxoLNKpPAuly9J74iATok=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Roger Quadros" <roger.quadros@nokia.com>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, sshtylyov@mvista.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/3] usb: gadget: storage: Add fsg_get_toc helper
References: <1302015569-9668-1-git-send-email-roger.quadros@nokia.com>
 <1302015569-9668-2-git-send-email-roger.quadros@nokia.com>
 <op.vtg1yhef3l0zgt@mnazarewicz-glaptop> <4DCA3F90.1080208@nokia.com>
Date: Wed, 11 May 2011 14:19:10 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vvbgh8ge3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <4DCA3F90.1080208@nokia.com>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 04/05/2011 06:43 PM, ext Michal Nazarewicz wrote:
>> On Tue, 05 Apr 2011 16:59:27 +0200, Roger Quadros wrote:
>>> + default:
>>> + /* Multi-session, PMA, ATIP, CD-TEXT not supported/required */
>>> + return -EINVAL;

> On 04/05/2011 06:43 PM, ext Michal Nazarewicz wrote:
>> Can we fall back to the old behaviour here?

On Wed, 11 May 2011 09:49:36 +0200, Roger Quadros <roger.
> What old behaviour? I didn't understand.

Before we were just ignoring the type of ToC requested, right?
So can we fail back to the ToC we served then when we hit
an unsupported TOC?  Or does it make no sense at all?  I'm not
saying it does.  It probably doesn't. ;)

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
