Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1CYMw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:52:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48747 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1CYMw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:52:27 -0400
Message-ID: <4D8C8FB1.7030703@ru.mvista.com>
Date: Fri, 25 Mar 2011 15:50:57 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Libor Pechacek <lpechacek@suse.cz>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: remove dead code from usb_deregister_dev()
References: <20110324132426.GA27561@fm.suse.cz> <4D8B48D2.1050704@ru.mvista.com> <20110325083458.GB30773@fm.suse.cz>
In-Reply-To: <20110325083458.GB30773@fm.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 25-03-2011 11:34, Libor Pechacek wrote:

>>> The `name' variable is unused in usb_deregister_dev() since commit d6e5bcf.

>>     Please also specify that commit's summary in parens for the human
>> readers,

> OK, sounds sane.  Updated patch will follow.

>> as asked by Linus.

> Can you please post a reference to the thread?  I'd like to read it but can't
> find it.

    No, sorry, can't -- that was long ago, and I didn't save it.

> Libor

WBR, Sergei
