Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2CEM47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:56:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49967 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965Ab2CEM46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:56:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.213.35.196 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F54B816.7070105@suse.cz>
Date: Mon, 05 Mar 2012 13:56:54 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Jiri Slaby <jirislaby@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Tony Luck <tony.luck@intel.com>, raven@themaw.net
Subject: Re: Build broken on s390 and ia64 [was: Linux 2.6.32.58]
References: <20120304180911.GA7336@kroah.com> <4F54A46A.6000305@suse.cz> <20120305120241.GA3627@osiris.boeblingen.de.ibm.com> <4F54B618.1090301@suse.cz> <20120305125459.GF30594@1wt.eu>
In-Reply-To: <20120305125459.GF30594@1wt.eu>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 01:54 PM, Willy Tarreau wrote:
> Does anybody know if other archs were broken ?

PPC looks fine so far (not all builds here have finished already). I
don't know about others.

thanks,
-- 
js
suse labs
