Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1C2LXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:23:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56411 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab1C2LXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:23:38 -0400
Message-ID: <4D91C0DD.1000802@ru.mvista.com>
Date: Tue, 29 Mar 2011 15:22:05 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Hardy <shardy@redhat.com>
CC: Greg KH <gregkh@suse.de>, mjg@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH 2/3] Resend : Fix memory leak in qcserial driver
References: <1301321186.4397.13.camel@shardy.csb> <20110328142148.GA19521@suse.de> <20110328173854.GB7030@shardy.csb>
In-Reply-To: <20110328173854.GB7030@shardy.csb>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-03-2011 21:38, Steven Hardy wrote:

    Posting all 3 patches having the same sucject is not a good idea.

> Patch 2 of 3, addresses the problem where serial->private can end up pointing to freed memory in the event qcprobe fails & returns -ENODEV

    You still didn't wrap the changelog text properly.

> Original description:
> 3 - Don't assign serial->private when doing the kzalloc or serial->private ends up pointing to freed memory in the event we return -ENODEV, instead call usb_set_serial_data(serial, data) at the end of the function, and only have one return-point.

WBR, Sergei
