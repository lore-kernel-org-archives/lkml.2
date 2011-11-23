Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab1KWKO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:14:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39289 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1KWKOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:14:55 -0500
Message-ID: <4ECCC79A.8030804@suse.cz>
Date: Wed, 23 Nov 2011 11:14:50 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111114 Thunderbird/9.0
MIME-Version: 1.0
To: Havard Skinnemoen <hskinnemoen@google.com>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: tty related lockdep trace during bootup on 3.2-rc2
References: <20111123033850.GA11380@redhat.com> <CAFQmdRYTgQOb53kQOvk1jubZbvaOrfjVCq4aG1H0ceshw2vVPA@mail.gmail.com> <4ECCC6F3.8000403@suse.cz>
In-Reply-To: <4ECCC6F3.8000403@suse.cz>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 11:12 AM, Jiri Slaby wrote:
> Also it looks like you have a leak in disconnect when there are users
> still. If I am looking correctly?

No, you are freeing it on the last close...

thanks,
-- 
js
suse labs
