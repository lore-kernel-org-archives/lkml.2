Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab1A1Mj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 07:39:27 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64409 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab1A1Mj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 07:39:26 -0500
Message-ID: <4D42B8B4.40404@ru.mvista.com>
Date: Fri, 28 Jan 2011 15:38:12 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Davidlohr Bueso <dave@gnu.org>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] USB: tools: Add a Makefile
References: <1296157174.2113.6.camel@offworld>	 <4D42B436.8070901@ru.mvista.com> <1296217427.2169.0.camel@offworld>
In-Reply-To: <1296217427.2169.0.camel@offworld>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-01-2011 15:23, Davidlohr Bueso wrote:

>> On 27-01-2011 22:39, Davidlohr Bueso wrote:

>>> I originally sent this in several months ago, but never got around to correcting the changes, so... here it is.

>>      This remark should follow the --- tear line, to be automatically stripped
>> when applying the patch.

> It wasn't meant for the log, that's why it's above the tear line.

    Everything above the tearline gets into the changelog. If it wasn't meant 
to, it should be below the tearline, or have to be manually edited out of it.

> Thanks.

WBR, Sergei
