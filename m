Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1KCVsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:48:38 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:52638 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752395Ab1KCVsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:48:36 -0400
Message-ID: <4EB30C0B.8080200@xenotime.net>
Date: Thu, 03 Nov 2011 14:47:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        Mark Einon <mark.einon@gmail.com>
Subject: Re: linux-next: Tree for Nov 3 (staging/et131x)
References: <20111103172036.0795ce9559ab2dbfd5740a26@canb.auug.org.au>
In-Reply-To: <20111103172036.0795ce9559ab2dbfd5740a26@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2011 11:20 PM, Stephen Rothwell wrote:
> Hi all,


When CONFIG_PM_SLEEP is not enabled:

drivers/staging/et131x/et131x.c:5489:12: error: 'et131x_pci_setup' undeclared here (not in a function)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
