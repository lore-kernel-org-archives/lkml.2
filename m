Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab2DHMto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 08:49:44 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3549 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab2DHMtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 08:49:43 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
Message-ID: <4F818952.3010609@broadcom.com>
Date: Sun, 8 Apr 2012 14:49:22 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keith Packard" <keithp@keithp.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Stephen Hemminger" <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
 <20120407200355.6be37c34@pyramind.ukuu.org.uk>
In-Reply-To: <20120407200355.6be37c34@pyramind.ukuu.org.uk>
X-WSS-ID: 639F544A3IO2137586-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2012 09:03 PM, Alan Cox wrote:
>> You do not need to make dual licenses when licenses are compatible
>> with each other, and in fact at times this can confuse developers / legal.
>
> Firstly you are out of order touching the licensing tags of other vendors
> code. Absolutely and utterly. So nobody should for example be touching an
> Intel MODULE_LICENSE() tag without the say so of Intel legal.

As the patch also includes driver code that Broadcom contributed to the 
kernel, I am inclined to agree. But to me it is not clear whether the 
MODULE_LICENSE() tag holds a true legal value. How does it relate to the 
legal disclaimer that is (probably) in each and every source file?

Gr. AvS

